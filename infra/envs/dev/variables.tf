variable "aws_region" {
  description = "region the whole stack lives in"
  type        = string
}

variable "env" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "container_image" {
  type    = string
  default = "public.ecr.aws/nginx/nginx:1.27-alpine"
}

variable "task_cpu" {
  type = string
}

variable "task_memory" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "db_instance_class" {
  type = string
}

variable "db_backup_retention_days" {
  type = number
}

variable "db_deletion_protection" {
  type = bool
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_skip_final_snapshot" {
  type = bool
}
