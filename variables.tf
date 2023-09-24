variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "subnet_ids" {
  description = "Subnets used for auto-scaling group"
  type        = list(string)
  default     = ["aws_subnet.cicd_subnet_a.id", "aws_subnet.cicd_subnet_b.id", "aws_subnet.cicd_subnet_c.id"]
}

/*
variable "zone_b" {
  description = "AWS Availability Zone"
  type        = string
  default     = "us-west-2b"
}

variable "zone_a" {
   description = "AWS Availability Zone"
   type        = string
   default     = "us-west-2a"
}
*/

variable "instance_type" {
  description = "Instance CICD runs on (2 core min)"
  type    = string
  default = "t2.2xlarge"
}

variable "ami" {
  description = "AMI for CICD isntance"
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
  default     = 3
}

variable "min_max_size" {
  description = "Minimum and maximum size for the Auto Scaling Group."
  type        = tuple([number, number])
  default     = [3, 6]
}

variable "custom_tags" {
  description = "Custom tags to apply to the Auto Scaling Group instances"
  type        = list(map(string))
  default     = []
}
