#Create the launch template for your Auto Scale Group
resource "aws_launch_template" "cicd_launch_template" {
  name_prefix = "CICD-"
  image_id = var.ami

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 50
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false
  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type
  key_name = var.keys

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    description = "Primary network interface"
    device_index = 0
    security_groups = [aws_security_group.cicd_sg.id]
  }

  user_data = base64encode(<<-EOF
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
  )
}

#Create your Auto Scale Group
resource "aws_autoscaling_group" "cicd_asg" {
  name = "CICD-ASG"
  launch_template {
    id = aws_launch_template.cicd_launch_template.id
    version = aws_launch_template.cicd_launch_template.latest_version
  }
  desired_capacity = var.desired_capacity
  min_size = var.min_max_size[0]
  max_size = var.min_max_size[1]
  vpc_zone_identifier = [aws_subnet.cicd_subnet_a.id, aws_subnet.cicd_subnet_b.id, aws_subnet.cicd_subnet_c.id]
  target_group_arns = [aws_lb_target_group.jenkins_8080.arn, aws_lb_target_group.maven_8010.arn, aws_lb_target_group.sonarqube_9000.arn]

  tag {
    key                 = "Name"
    value               = "CICD"
    propagate_at_launch = true
  }
}

#Attach loadbalancer to instances created by Auto Scale Group
resource "aws_autoscaling_attachment" "jenkins_target" {
  autoscaling_group_name = aws_autoscaling_group.cicd_asg.name
  lb_target_group_arn  = aws_lb_target_group.jenkins_8080.arn
}

resource "aws_autoscaling_attachment" "sonarqube_target" {
  autoscaling_group_name = aws_autoscaling_group.cicd_asg.name
  lb_target_group_arn  = aws_lb_target_group.sonarqube_9000.arn
}

resource "aws_autoscaling_attachment" "maven_target" {
  autoscaling_group_name = aws_autoscaling_group.cicd_asg.name
  lb_target_group_arn  = aws_lb_target_group.maven_8010.arn
}
