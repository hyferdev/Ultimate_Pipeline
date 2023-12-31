variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}

variable "instance_type" {
  description = "Instance CICD runs on (2 core min)"
  type    = string
  default = "t2.2xlarge"
}

variable "ami" {
  description = "us-west-2 Ubuntu AMI"
  type    = string
  default = "ami-03f65b8614a860c29"
}

variable "keys" {
  description = "Keys used to access the isntance"
  type    = string
  default = "RedKeys"
}

variable "hzoneid" {
  description = "Hosted Zone ID defined in Terraform Cloud"
}

variable "domain_name" {
  description = "The main domain name"
  type        = string
  default     = "desire-projects.com"
}

variable "desired_capacity" {
  description = "Desired number of instances for the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "min_max_size" {
  description = "Minimum and maximum size for the Auto Scaling Group."
  type        = tuple([number, number])
  default     = [1, 6]
}
