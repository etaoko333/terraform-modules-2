# Create a database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.project_name}-${var.environment}-database-subnets"
  subnet_ids = [var.private_data_subnet_az1_id, var.private_data_subnet_az2_id]
  description = "subnets for database instance"

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnets"
  }
}

# # Define MySQL Parameter Group for RDS
resource "aws_db_parameter_group" "mysql_parameter_group" {
  name        = "mysql-para-group"
  family      = "mysql8.0"
  description = "MySQL Parameter Group"

  parameter {
    name  = "max_connections"
    value = "200"
  }
}

#launch an rds instance from a database
resource "aws_db_instance" "dev_rds_db" {
  instance_class          = var.database_instance_class
  identifier              = "dev-rds-db"
  engine                  = "mysql"
  engine_version          = "8.0.36"
  skip_final_snapshot     = true
  availability_zone       = var.availability_zone_1
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [var.database_security_group_id]
  multi_az                = var.multi_az_deployment
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  storage_encrypted       = true
  backup_retention_period = 7
  publicly_accessible     = true
}
