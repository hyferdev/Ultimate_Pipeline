/*
# Creates an AWS Linux VM
resource "aws_instance" "cicd_instance" {
  ami = var.ami
  subnet_id = aws_subnet.cicd_subnet.id  
  associate_public_ip_address = true  
  instance_type = var.instance_type
  key_name = var.keys
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install openjdk-11-jre -y
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo apt install maven -y
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce -y
    git clone https://github.com/hyferdev/Jenkins-Zero-To-Hero.git
    chown ubuntu:ubuntu -R Jenkins-Zero-To-Hero/
    cd /Jenkins-Zero-To-Hero/java-maven-sonar-argocd-helm-k8s/spring-boot-app/ && mvn clean package
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ubuntu
    su ubuntu -c "docker build -t ultimate-cicd-pipeline:v1 /Jenkins-Zero-To-Hero/java-maven-sonar-argocd-helm-k8s/spring-boot-app/"
    su ubuntu -c "docker run -d -p 8010:8080 -t ultimate-cicd-pipeline:v1"
    sudo apt install unzip
    sudo adduser --disabled-password --gecos "" sonarqube
    cd /home/sonarqube && sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
    unzip sonarqube-9.4.0.54424.zip
    sudo chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
    sudo chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
    rm sonarqube-9.4.0.54424.zip
    su sonarqube -c "/home/sonarqube/sonarqube-9.4.0.54424/bin/linux-x86-64/sonar.sh start"
    EOF
  user_data_replace_on_change = true
  tags = {
    Name = "CICD_EC2"
  }
}
*/

# Create a scale group launch configuration
resource "aws_launch_configuration" "cicd_launch_config" {
  name_prefix = "CICD-"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.keys
  security_groups = [aws_security_group.cicd_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install openjdk-11-jre -y
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo apt install maven -y
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce -y
    git clone https://github.com/hyferdev/Jenkins-Zero-To-Hero.git
    chown ubuntu:ubuntu -R Jenkins-Zero-To-Hero/
    cd /Jenkins-Zero-To-Hero/java-maven-sonar-argocd-helm-k8s/spring-boot-app/ && mvn clean package
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ubuntu
    su ubuntu -c "docker build -t ultimate-cicd-pipeline:v1 /Jenkins-Zero-To-Hero/java-maven-sonar-argocd-helm-k8s/spring-boot-app/"
    su ubuntu -c "docker run -d -p 8010:8080 -t ultimate-cicd-pipeline:v1"
    sudo apt install unzip
    sudo adduser --disabled-password --gecos "" sonarqube
    cd /home/sonarqube && sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
    unzip sonarqube-9.4.0.54424.zip
    sudo chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
    sudo chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
    rm sonarqube-9.4.0.54424.zip
    su sonarqube -c "/home/sonarqube/sonarqube-9.4.0.54424/bin/linux-x86-64/sonar.sh start"
    EOF
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "cicd_asg" {
  name_prefix = "CICD-"
  launch_configuration = aws_launch_configuration.cicd_launch_config.name
  desired_capacity = var.desired_capacity
  min_size = var.min_max_size[0]
  max_size = var.min_max_size[1]
  vpc_zone_identifier = var.subnet_ids
  load_balancers = [aws_lb.cicd_lb.arn]

  dynamic "tag" {
    for_each = range(var.desired_capacity)
    content {
      key                 = "Name"
      value               = "CICD-${tag.key + 1}"
      propagate_at_launch = true
    }
  }
}

# Register instance to app load balancer
resource "aws_lb_target_group_attachment" "jenkins_target_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_8080.arn
  target_id        = aws_autoscaling_group.cicd_asg.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "sonarqube_target_attachment" {
   target_group_arn = aws_lb_target_group.sonarqube_9000.arn
   target_id        = aws_autoscaling_group.cicd_asg.id
   port             = 9000
 }

resource "aws_lb_target_group_attachment" "maven_target_attachment" {
   target_group_arn = aws_lb_target_group.maven_8010.arn
   target_id        = aws_autoscaling_group.cicd_asg.id
   port             = 8010
 }
