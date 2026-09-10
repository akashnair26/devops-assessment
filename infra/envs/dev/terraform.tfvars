aws_region = "ap-south-1"
env        = "dev"

azs      = ["ap-south-1a", "ap-south-1b"]
vpc_cidr = "10.20.0.0/16"

container_port  = 80
container_image = "public.ecr.aws/nginx/nginx:1.27-alpine"
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1

db_instance_class        = "db.t3.micro"
db_backup_retention_days = 1
db_deletion_protection   = false
db_multi_az              = false
db_skip_final_snapshot   = true
