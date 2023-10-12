# Create Network Load Balancers for ports 8080, 8010, and 9000
resource "aws_lb" "jenkins_nlb" {
  name               = "jenkins-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.cicd_subnet_a.id, aws_subnet.cicd_subnet_b.id, aws_subnet.cicd_subnet_c.id]
  enable_deletion_protection = false
}

resource "aws_lb" "maven_nlb" {
  name               = "maven-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.cicd_subnet_a.id, aws_subnet.cicd_subnet_b.id, aws_subnet.cicd_subnet_c.id]
  enable_deletion_protection = false
}

resource "aws_lb" "sonarqube_nlb" {
  name               = "sonarqube-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.cicd_subnet_a.id, aws_subnet.cicd_subnet_b.id, aws_subnet.cicd_subnet_c.id]
  enable_deletion_protection = false
}

# Create load balancer listeners
resource "aws_lb_listener" "jenkins_nlb_listener" {
  load_balancer_arn = aws_lb.jenkins_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_8080.arn
  }
}

resource "aws_lb_listener" "maven_nlb_listener" {
  load_balancer_arn = aws_lb.maven_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.maven_8010.arn
  }
}

resource "aws_lb_listener" "sonarqube_nlb_listener" {
  load_balancer_arn = aws_lb.sonarqube_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_9000.arn
  }
}

# Create target groups for the NLBs
resource "aws_lb_target_group" "jenkins_8080" {
  name        = "jenkins-8080"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id
  stickiness {
    type = "source_ip"
  }
}

resource "aws_lb_target_group" "maven_8010" {
  name        = "maven-8010"
  port        = 8010
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id
  stickiness {
    type = "source_ip"
  }
}

resource "aws_lb_target_group" "sonarqube_9000" {
  name        = "sonarqube-9000"
  port        = 9000
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id
  stickiness {
    type = "source_ip"
  }
}
