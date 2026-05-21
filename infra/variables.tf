variable "project_name" {
  type    = string
  default = "cloudops-task-tracker"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "availability_zone" {
  type    = string
  default = "eu-central-1a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR format, for example 11.22.33.44/32."
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "public_key_path" {
  type    = string
  default = "/home/kali/.ssh/cloudops-task-tracker.pub"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in owner/name format, for example your-login/cloudops-task-tracker."
}
