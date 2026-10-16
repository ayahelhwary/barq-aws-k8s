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

variable "vpc_cidr" {
  description = "IP range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range of the public subnet (EC2 nodes)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "IP ranges of the two private DB subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}
