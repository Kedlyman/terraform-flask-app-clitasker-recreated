module "vpc" {
  source = "./modules/vpc"

  aws_region            = var.aws_region
  project_name          = "terraform-flask-app"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr_1  = "10.0.1.0/24"
  public_subnet_cidr_2  = "10.0.2.0/24"
  private_subnet_cidr_1 = "10.0.3.0/24"
  private_subnet_cidr_2 = "10.0.4.0/24"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  my_ip_cidr = "${chomp(data.http.my_ip.response_body)}/32"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = "aws-cli-project-db-password-2"
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

module "security_groups" {
  source       = "./modules/security_groups"
  vpc_id       = module.vpc.vpc_id
  project_name = "terraform-flask-app"
  my_ip_cidr   = local.my_ip_cidr
}

module "rds" {
  source             = "./modules/rds"
  project_name       = "terraform-flask-app"
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id

  db_username        = local.db_secret.username
  db_password        = local.db_secret.password
}

module "s3" {
  source       = "./modules/s3"
  project_name = "terraform-flask-app"
}

module "iam" {
  source       = "./modules/iam"
  project_name = "terraform-flask-app"
  bucket_name  = module.s3.bucket_name
  secret_name  = "aws-cli-project-db-password-2"
  aws_region   = var.aws_region
}

module "ec2" {
  source               = "./modules/ec2"
  key_name             = "aws-terraform-project-key"
  public_key_path      = "/home/cloudshell-user/.ssh/aws-terraform-project-key.pub"
  instance_name        = "terraform-flask-app-ec2"
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_id    = module.security_groups.ec2_sg_id
  instance_profile_name = module.iam.instance_profile_name
}

module "alb" {
  source            = "./modules/alb"
  project_name      = "terraform-flask-app"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ec2_instance_id   = module.ec2.instance_id
}

module "lambda" {
  source       = "./modules/lambda"
  project_name = "terraform-flask-app"
  bucket_name  = module.s3.bucket_name
}

module "monitoring" {
  source            = "./modules/monitoring"
  project_name      = "terraform-flask-app"
  ec2_instance_id   = module.ec2.instance_id
  tg_arn            = module.alb.tg_arn       
  lb_dimension      = module.alb.lb_dimension
}
