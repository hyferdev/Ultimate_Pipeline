/*
# Create an application load balancer that listens on port 80
resource "aws_lb" "cicd_lb" {
  name               = "cicd-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.cicd_subnet_a.id, aws_subnet.cicd_subnet_b.id, aws_subnet.cicd_subnet_c.id]
  enable_deletion_protection = false
  enable_http2 = true
}

resource "aws_lb_listener" "cicd_lb_listener" {
  load_balancer_arn = aws_lb.cicd_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      status_code     = "200"
      message_body    = "OK"
    }
  }
}

# Create target groups for CICD services on ports 8080, 8010, and 9000
resource "aws_lb_target_group" "jenkins_8080" {
  name        = "jenkins-8080"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "sonarqube_9000" {
  name        = "sonarqube-9000"
  port        = 9000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    port                = 9000
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "maven_8010" {
  name        = "maven-8010"
  port        = 8010
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cicd_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    port                = 8010
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

#Create listener rule to route hosted subzone traffic to ports
resource "aws_lb_listener_rule" "jenkins_rule" {
  listener_arn = aws_lb_listener.cicd_lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_8080.arn
  }

  condition {
    host_header {
      values = ["jenkins.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "sonarqube_rule" {
  listener_arn = aws_lb_listener.cicd_lb_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_9000.arn
  }

  condition {
    host_header {
      values = ["sonarqube.${var.domain_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "maven_rule" {
  listener_arn = aws_lb_listener.cicd_lb_listener.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.maven_8010.arn
  }

  condition {
    host_header {
      values = ["maven.${var.domain_name}"]
    }
  }
}
*/
