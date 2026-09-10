variable "env" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_sg_id" {
  type = string
}

variable "db_name" {
  description = "name of the actual database inside the instance"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  type    = string
  default = "app_admin"
}

variable "instance_class" {
  description = "size of the rds box"
  type        = string
}

variable "allocated_storage" {
  description = "gb"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = ""
  type        = string
  default     = "16.4"
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type = bool
}
