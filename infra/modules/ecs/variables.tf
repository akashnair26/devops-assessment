variable "env" {
  description = ""
  type        = string
}

variable "aws_region" {
  description = "used for the log group config, nothing fancier"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "container_image" {
  description = "placeholder image, swap for the real app later"
  type        = string
  default     = "public.ecr.aws/nginx/nginx:1.27-alpine"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "task_cpu" {
  description = "fargate cpu units as a string, e.g. 256"
  type        = string
}

variable "task_memory" {
  description = "fargate memory in mb as a string, e.g. 512"
  type        = string
}

variable "desired_count" {
  description = "how many tasks stay running"
  type        = number
  default     = 1
}
