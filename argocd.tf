# Create our ArgoCD instance
resource "aws_instance" "cicd_instance" {
  ami = var.ami
  subnet_id = aws_subnet.cicd_subnet_a.id
  associate_public_ip_address = true
  instance_type = var.instance_type
  key_name = var.keys
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install wget
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install  -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm -f /minikube-linux-amd64
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo rm -f /kubectl
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce -y
    sudo systemctl enable --now docker
    sudo useradd -m k8svc
    sudo usermod -aG docker k8svc && newgrp docker
    su k8svc -c 'minikube start'
    su k8svc -c 'curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/install.sh | bash -s v0.25.0'
    su k8svc -c 'kubectl create -f https://operatorhub.io/install/argocd-operator.yaml'
    EOF
  user_data_replace_on_change = true
  tags = {
    Name = "ArgoCD Cluster"
  }
}
