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

variable "allowed_cidrs" {
  description = "Your public IP(s) in CIDR form, allowed to SSH and to reach the app"
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidrs) > 0 && alltrue([for c in var.allowed_cidrs : can(cidrnetmask(c)) && c != "0.0.0.0/0"])
    error_message = "Provide at least one valid IPv4 CIDR (for example 1.2.3.4/32). 0.0.0.0/0 is not allowed."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key uploaded to AWS (the private key never leaves your machine)"
  type        = string
  default     = "~/.ssh/barq-lab.pub"
}
