variable "project_name" {
  description = "The name of the project, used to name the bucket"
  type        = string
}

variable "app_tag" {
  description = "Tag value for the project"
  type        = string
  default     = "terraform-flask-app-S3"
}