variable "aws_region" {}
variable "project_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  default = "10.0.4.0/24"
}