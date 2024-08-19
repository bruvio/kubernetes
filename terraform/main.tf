provider "aws" {
  region  = "eu-west-2"
  profile = "masterbruvio"
}

variable "key-name" {
  default = "deployer-key"
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/deployer_key.pub")
}

resource "aws_instance" "example" {
  count           = 3
  ami             = "ami-08aa7f71c822e5cc9" # Ubuntu AMI
  instance_type   = "t2.large"
  security_groups = [aws_security_group.allow_all.name]
  key_name        = aws_key_pair.deployer.key_name
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "${count.index == 0 ? "master" : "worker-${count.index}"}"
  }
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  #  to install Client Version: v1.31.0
  # Kustomize Version: v5.4.2
  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Set hostname based on instance tags
    HOSTNAME="${count.index == 0 ? "master" : "worker-${count.index}"}"
    sudo hostnamectl set-hostname $HOSTNAME


    # Install Docker
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker

    # Install Kubernetes packages
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg awscli
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list




    
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl vim git curl wget 
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet

    sudo ufw disable
    # Disable swap
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
    # echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/containerd.conf
    # echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/kubernetes.conf
    # sudo sysctl --system




    # Enable kernel modules for Kubernetes
    # sudo modprobe br_netfilter
    # sudo bash -c 'echo "net.bridge.bridge-nf-call-iptables = 1" > /etc/sysctl.d/k8s.conf'
    # sudo sysctl --system

    # Determine node type (master or worker) based on hostname
    HOSTNAME=$(hostname)


    # If this is the master node
    if [ "$(hostname)" == "master" ]; then
      #next line is getting EC2 instance IP, for kubeadm to initiate cluster
      #we need to get EC2 internal IP address- default ENI is eth0
      export ipaddr=`ip address|grep eth0|grep inet|awk -F ' ' '{print $2}' |awk -F '/' '{print $1}'`
      export pubip=`dig +short myip.opendns.com @resolver1.opendns.com`

      # the kubeadm init won't work entel remove the containerd config and restart it.
      rm /etc/containerd/config.toml
      systemctl restart containerd

      #Kubernetes cluster init
      #You can replace 172.16.0.0/16 with your desired pod network
      kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=172.16.0.0/16 --apiserver-cert-extra-sans=$pubip > /tmp/restult.out
      cat /tmp/restult.out

      #to get join commdn
      tail -2 /tmp/restult.out > /tmp/join_command.sh;
      aws s3 cp /tmp/join_command.sh s3://${s3buckit_name};
      #this adds .kube/config for root account, run same for ubuntu user, if you need it
      mkdir -p /root/.kube;
      cp -i /etc/kubernetes/admin.conf /root/.kube/config;
      cp -i /etc/kubernetes/admin.conf /tmp/admin.conf;
      chmod 755 /tmp/admin.conf

      #Add kube config to ubuntu user.
      mkdir -p /home/ubuntu/.kube;
      cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config;
      chmod 755 /home/ubuntu/.kube/config


      #to copy kube config file to s3
      # aws s3 cp /etc/kubernetes/admin.conf s3://${s3buckit_name}

      #Uncomment next line if you want calico Cluster Pod Network
      curl -o /root/calico.yaml https://docs.projectcalico.org/v3.16/manifests/calico.yaml
      sleep 5
      kubectl --kubeconfig /root/.kube/config apply -f /root/calico.yaml
      systemctl restart kubelet

      # Apply kubectl Cheat Sheet Autocomplete
      source <(kubectl completion bash) # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
      echo "source <(kubectl completion bash)" >> /home/ubuntu/.bashrc # add autocomplete permanently to your bash shell.
      echo "source <(kubectl completion bash)" >> /root/.bashrc # add autocomplete permanently to your bash shell.
      alias k=kubectl
      complete -o default -F __start_kubectl k
      echo "alias k=kubectl" >> /home/ubuntu/.bashrc
      echo "alias k=kubectl" >> /root/.bashrc
      echo "complete -o default -F __start_kubectl k" >> /home/ubuntu/.bashrc
      echo "complete -o default -F __start_kubectl k" >> /root/.bashrc

      # Output the join command for the worker nodes
      kubeadm token create --print-join-command > /home/ubuntu/kubeadm_join_command.sh
      sudo chmod +x /home/ubuntu/kubeadm_join_command.sh
    else
      export ipaddr=`ip address|grep eth0|grep inet|awk -F ' ' '{print $2}' |awk -F '/' '{print $1}'`


      # the kubeadm init won't work entel remove the containerd config and restart it.
      rm /etc/containerd/config.toml
      systemctl restart containerd

      # to insure the join command start when the installion of master node is done.
      sleep 1m

      aws s3 cp s3://${s3buckit_name}/join_command.sh /tmp/.
      chmod +x /tmp/join_command.sh
      bash /tmp/join_command.sh
      # Wait until the join command script is available from the master
      while [ ! -f /home/ubuntu/kubeadm_join_command.sh ]; do
        sleep 10
      done

      # Join the Kubernetes cluster
      sudo bash /home/ubuntu/kubeadm_join_command.sh
    fi
  EOF
}

output "instance_public_ips" {
  value = aws_instance.example[*].public_ip
}


