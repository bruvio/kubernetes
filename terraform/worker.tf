resource "aws_instance" "workers" {
  count                  = var.enable_workers ? 2 : 0
  ami                    = "ami-08aa7f71c822e5cc9" # Ubuntu AMI
  instance_type          = var.worker_type
  vpc_security_group_ids = [aws_security_group.control_plane_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  root_block_device {
    volume_type = var.worker_disk_type
    volume_size = var.worker_disk_size
    iops        = var.worker_disk_iops
    encrypted   = true
    tags = {
      Name = "${var.cluster_name}-controller-${count.index}"
    }
  }
  subnet_id            = element(module.vpc.public_subnets, count.index)
  iam_instance_profile = aws_iam_instance_profile.worker.name
  tags = {
    Name                     = "worker-${count.index + 1}"
    "kubernetes.io/cluster/" = "bruvio"
  }
  associate_public_ip_address = true
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  metadata_options {
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_put_response_hop_limit
  }
  #  to install Client Version: v1.31.0
  # Kustomize Version: v5.4.2
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Set hostname based on index∫
    HOSTNAME="worker-${count.index + 1}"
    HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
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
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list





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
    sudo bash ./kubeadm_join_command.sh
    
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
      private_key = file("deployer_key")
      host        = self.public_ip
    }

  }
}
