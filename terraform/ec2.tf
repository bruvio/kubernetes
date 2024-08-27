






resource "aws_instance" "master" {
  ami                    = "ami-08aa7f71c822e5cc9" # Ubuntu AMI
  instance_type          = var.instance_type_master
  vpc_security_group_ids = [aws_security_group.control_plane_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  # root_block_device {
  #   volume_size = 20
  # }
  subnet_id            = module.vpc.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.master.name
  tags = {
    Name                     = "master"
    "kubernetes.io/cluster/" = "${var.cluster}"

  }
  associate_public_ip_address = true
  private_dns_name_options {
    hostname_type = "resource-name"
  }

  user_data = <<-EOF
    #!/bin/bash
    export CLUSTER_NAME="bruvio"
    export K8S_VERSION="1.30.0"
    export REGION="eu-west-2"
    export NODE_ROLE_ARN="${aws_iam_role.master.arn}"
    export CLUSTER_CIDR="${module.vpc.private_subnets_cidr_blocks[0]}"

    # Set plugin for in-cluster networking, set volume plugin to default storage solution for kcm
    export NET_PLUGIN="kubenet"
    export EXTERNAL_CLOUD_VOLUME_PLUGIN="aws"

    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Set hostname based on index
    # HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
    HOSTNAME="master"
    sudo hostnamectl set-hostname $HOSTNAME
    sudo systemctl restart systemd-hostnamed

    # Install Docker
    sudo apt-get install -y docker.io
    sudo echo '{"exec-opts": ["native.cgroupdriver=systemd"], "log-driver": "json-file", "log-opts": {"max-size": "100m"}, "storage-driver": "overlay2"}' > /etc/docker/daemon.json
    sudo systemctl enable docker
    sudo systemctl start docker

    # Install Kubernetes packages
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg awscli bash-completion
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list





    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl vim git curl wget nftables make
 
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet

    sudo ufw disable
    # Disable swap
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
    modprobe overlay
    modprobe br_netfilter
    echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/kubernetes.conf


    
    sudo systemctl enable kubelet
    sudo kubeadm config images pull --cri-socket unix:///run/containerd/containerd.sock
    INSTANCE_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    
 
    sudo kubeadm init  --apiserver-advertise-address=$INSTANCE_PRIVATE_IP --pod-network-cidr="${module.vpc.private_subnets_cidr_blocks[0]}" 
    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config


    echo "installing calico"
    sudo su
    export KUBECONFIG=/etc/kubernetes/admin.conf
    

    # Step 6: Install Network Plugin on the Master (Calico)
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml 
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml


    # Output the join command for the worker nodes
    kubeadm token create --print-join-command > /home/ubuntu/kubeadm_join_command.sh
    chmod +x /home/ubuntu/kubeadm_join_command.sh
    aws s3 cp /home/ubuntu/kubeadm_join_command.sh s3://${random_pet.bucket_name.id}/kubeadm_join_command.sh

    echo "installing ks9 dashboard"
    curl -sS https://webinstall.dev/k9s | bash
    sudo su
    source ~/.config/envman/PATH.env
    k9s version

    echo "installing kubernetes dashboard via helm"
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    apt-get update
    apt-get install helm
    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

    helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

    # copy all files from s3 to the master node
    aws s3 cp  s3://${random_pet.bucket_name.id}/ /home/ubuntu/ --recursive
    sudo echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc

    sudo su 
    export KUBECONFIG=/etc/kubernetes/admin.conf

    

    # Taint master nodes to allow scheduling on them (optional for small setups)
    sudo su
    kubectl taint nodes $HOSTNAME node-role.kubernetes.io/control-plane:NoSchedule-
    
    sudo wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz


    # Set up environment variables
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
    echo "export GOPATH=\$HOME/go" >> ~/.bashrc
    echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc

    # Create Go workspace directories
    sudo mkdir -p ~/go/{bin,pkg,src}

    # Source the .bashrc to apply environment variables in this script
    source ~/.bashrc


    # Clone cloud-provider-aws
    git clone https://github.com/kubernetes/cloud-provider-aws
    # Clone network plugins
    git clone https://github.com/containernetworking/plugins
    sudo mkdir -p /etc/cni/net.d  /opt/cni/bin
   
    # Build and configure network plugins
    cd plugins
    sudo su
    ./build_linux.sh
    sudo cp bin/* /opt/cni/bin/

    sudo echo "{\"cniVersion\":\"0.3.1\",\"name\":\"mynet\",\"plugins\":[{\"type\":\"bridge\",\"bridge\":\"cni0\",\"isGateway\":true,\"ipMasq\":true,\"ipam\":{\"type\":\"host-local\",\"subnet\":\"\${module.vpc.public_subnets[0]}\",\"routes\":[{\"dst\":\"0.0.0.0/0\"}]}},{\"type\":\"portmap\",\"capabilities\":{\"portMappings\":true},\"snat\":true}]}" > /etc/cni/net.d/10-mynet.conflist


    sudo echo '{"cniVersion":"0.3.1","type":"loopback"}' > /etc/cni/net.d/99-loopback.conf


    cd ../cloud-provider-aws
    ./hack/local-up-cluster.sh
    echo "### You can now use kubectl to interact with your cluster ###"

    LOG_DIR="/var/log/pods/"
    DESTINATION_DIR="/tmp/"

    mkdir -p $DESTINATION_DIR

    for file in $(find $LOG_DIR -type f -name "*.log"); do
        cp $file $DESTINATION_DIR/
    done

  EOF

  provisioner "remote-exec" {
    inline = [
      "/bin/bash -c \"timeout 600 sed '/finished at/q' <(tail -f /var/log/cloud-init-output.log)\""
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.private_key}")
      host        = self.public_ip
    }

  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }
  depends_on = [aws_security_group.control_plane_sg, module.vpc]
}

# provider "time" {}

# resource "time_sleep" "wait" {
#   create_duration = "245s"
# }

resource "aws_instance" "workers" {
  count                  = var.enable_workers ? 2 : 0
  ami                    = "ami-08aa7f71c822e5cc9" # Ubuntu AMI
  instance_type          = var.instance_type_worker
  vpc_security_group_ids = [aws_security_group.control_plane_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  # root_block_device {
  #   volume_size = 20
  # }
  subnet_id            = module.vpc.public_subnets[count.index]
  iam_instance_profile = aws_iam_instance_profile.worker.name
  tags = {
    Name                     = "worker-${count.index + 1}"
    "kubernetes.io/cluster/" = "${var.cluster}"
  }
  associate_public_ip_address = true
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }
  #  to install Client Version: v1.30.0
  # Kustomize Version: v5.4.2
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Set hostname based on index
    HOSTNAME="worker-${count.index + 1}"
    # HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
    sudo hostnamectl set-hostname $HOSTNAME
    sudo systemctl restart systemd-hostnamed

    # Install Docker
    sudo apt-get install -y docker.io
    sudo echo '{"exec-opts": ["native.cgroupdriver=systemd"], "log-driver": "json-file", "log-opts": {"max-size": "100m"}, "storage-driver": "overlay2"}' > /etc/docker/daemon.json

    sudo systemctl enable docker
    sudo systemctl start docker

    # Install Kubernetes packages
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg awscli bash-completion make
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list





    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl vim git curl wget nftables

    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet

    sudo ufw disable
    # Disable swap
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
    modprobe overlay
    modprobe br_netfilter
    echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/kubernetes.conf



    sudo systemctl enable kubelet
    aws s3 cp  s3://${random_pet.bucket_name.id}/kubeadm_join_command.sh /home/ubuntu/kubeadm_join_command.sh
    sudo bash kubeadm_join_command.sh
    
    LOG_DIR="/var/log/pods/"
    DESTINATION_DIR="/tmp/"

    mkdir -p $DESTINATION_DIR

    for file in $(find $LOG_DIR -type f -name "*.log"); do
        cp $file $DESTINATION_DIR/
    done
  EOF
  # depends_on = [aws_instance.master,time_sleep.wait]
  depends_on = [aws_instance.master, aws_security_group.control_plane_sg, module.vpc]

  provisioner "remote-exec" {
    inline = [
      "/bin/bash -c \"timeout 600 sed '/finished at/q' <(tail -f /var/log/cloud-init-output.log)\""
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.private_key}")
      host        = self.public_ip
    }

  }
}

# resource "aws_ec2_instance_state" "master" {
#   instance_id = aws_instance.master.id

#   state       = "stopped"
# }

# resource "aws_ec2_instance_state" "workers" {
#   count       = 2
#   instance_id = aws_instance.workers[count.index].id
#   state       = "stopped"

# }










