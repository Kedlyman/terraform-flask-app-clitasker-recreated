variable "project_name" {
  description = "The name of the project used for tagging and naming Lambda resources"
  type        = string
}

variable "bucket_name" {
  description = "The S3 bucket where the Lambda will store the daily summary"
  type        = string
}