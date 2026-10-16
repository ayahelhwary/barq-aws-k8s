variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used in resource names and tags"
  type        = string
  default     = "barq"
}
