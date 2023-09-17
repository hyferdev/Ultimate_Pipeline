variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "zone" {
  description = "AWS Availability Zone"
  type        = string
  default     = "us-west-2b"
}

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
