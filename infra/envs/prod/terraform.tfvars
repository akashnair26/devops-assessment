aws_region = "ap-south-1"
env        = "prod"

azs      = ["ap-south-1a", "ap-south-1b"]
vpc_cidr = "10.30.0.0/16"

container_port  = 80
container_image = "public.ecr.aws/nginx/nginx:1.27-alpine"
task_cpu        = "512"
task_memory     = "1024"
desired_count   = 2

db_instance_class        = "db.t3.medium"
db_backup_retention_days = 14
db_deletion_protection   = true
db_multi_az              = true
db_skip_final_snapshot   = false
