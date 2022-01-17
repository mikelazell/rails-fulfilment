resource "aws_db_instance" "rails_database" {
  allocated_storage            = 20
  engine                       = "postgres"
  engine_version               = "12.8"
  instance_class               = var.db_size
  name                         = var.database_name
  identifier                   = var.database_name
  username                     = var.db_user
  password                     = var.db_password
  parameter_group_name         = "default.postgres12"
  skip_final_snapshot          = true
  availability_zone            = var.db_availability_zone
  db_subnet_group_name         = module.vpc.database_subnet_group_name
  performance_insights_enabled = false
  vpc_security_group_ids       = [aws_security_group.app_db_security_group.id]


  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }
}