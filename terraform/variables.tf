
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name in AWS"
  type        = string
  default     = "mausam"
}

variable "project_name" {
  description = "Project and EC2 name"
  type        = string
  default     = "mausam"
}

variable "docker_image" {
  description = "Docker Hub image"
  type        = string
  default     = "shivam804453/mausam:latest"
}
