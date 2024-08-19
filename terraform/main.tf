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
      sudo kubeadm init --pod-network-cidr=192.168.0.0/16

      # Set up kubeconfig for the ubuntu user
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config

      # Install Calico network plugin
      kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

      # Output the join command for the worker nodes
      kubeadm token create --print-join-command > /home/ubuntu/kubeadm_join_command.sh
      sudo chmod +x /home/ubuntu/kubeadm_join_command.sh
    else
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


