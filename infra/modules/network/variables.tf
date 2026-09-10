variable "env" {
  description = "dev or prod, used for naming/tags"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr block for the vpc"
  type        = string
}

variable "azs" {
  description = "az names to spread subnets across, e.g. ap-south-1a/1b"
  type        = list(string)
}

variable "container_port" {
  description = ""
  type        = number
  default     = 80
}
