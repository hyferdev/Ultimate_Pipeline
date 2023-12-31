# Create hosted subzone records, hzoneid is set in Terraform Cloud
resource "aws_route53_record" "jenkis_record" {
  zone_id = var.hzoneid
  name    = "jenkins.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_nlb.dns_name
    zone_id                = aws_lb.jenkins_nlb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "sonarqube_record" {
  zone_id = var.hzoneid
  name    = "sonarqube.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.sonarqube_nlb.dns_name
    zone_id                = aws_lb.sonarqube_nlb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "maven_record" {
  zone_id = var.hzoneid
  name    = "maven.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.maven_nlb.dns_name
    zone_id                = aws_lb.maven_nlb.zone_id
    evaluate_target_health = true
  }
}
