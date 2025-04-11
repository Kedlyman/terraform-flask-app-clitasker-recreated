variable "project_name" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {}
variable "db_username" {
  default = "admin"
}
variable "db_password" {
  sensitive = true
}

variable "db_name" {
  default = "postgres"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_engine_version" {
  default = "17.2"
}

variable "allocated_storage" {
  default = 20
}
