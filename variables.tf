variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "mavencrest"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., staging, prod)"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type"
}

variable "ami_id" {
  type        = string
  description = "The custom AMI ID with Next.js and Nginx pre-installed"
}

variable "iam_role_name" {
  type        = string
  default     = "NeonSsmRead"
  description = "The role that reads Neon db string"
}

variable "ssm_parameter_name" {
  type        = string
  default     = "/nextjs/prod/DATABASE_URL"
  description = "The path to the Neon DB connection string in SSM Parameter Store"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "The ARN of your SSL certificate managed in AWS Certificate Manager (ACM)"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in the ASG"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in the ASG"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in the ASG"
}

variable "cpu_target_utilization" {
  type        = number
  description = "Target CPU utilization percentage for scaling"
  default     = 60.0
}

variable "domain_name" {
  type        = string
  description = "The custom domain name for the application"
}