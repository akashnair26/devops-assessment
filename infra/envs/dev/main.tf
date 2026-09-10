module "network" {
  source = "../../modules/network"

  env            = var.env
  vpc_cidr       = var.vpc_cidr
  azs            = var.azs
  container_port = var.container_port
}

module "ecs" {
  source = "../../modules/ecs"

  env                = var.env
  aws_region         = var.aws_region
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  alb_sg_id          = module.network.alb_sg_id
  ecs_sg_id          = module.network.ecs_sg_id

  container_image = var.container_image
  container_port  = var.container_port
  task_cpu        = var.task_cpu
  task_memory     = var.task_memory
  desired_count   = var.desired_count
}

module "rds" {
  source = "../../modules/rds"

  env                = var.env
  private_subnet_ids = module.network.private_subnet_ids
  rds_sg_id          = module.network.rds_sg_id

  instance_class          = var.db_instance_class
  backup_retention_period = var.db_backup_retention_days
  deletion_protection     = var.db_deletion_protection
  multi_az                = var.db_multi_az
  skip_final_snapshot     = var.db_skip_final_snapshot
}
