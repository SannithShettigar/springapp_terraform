data "aws_availability_zones" "available_zones" {}

# create security group for the database
resource "aws_security_group" "rds_security_group" {
  name        = "database security group"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress_sg_db.from_port
    to_port     = var.ingress_sg_db.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress_sg_db.from_port
    to_port     = var.egress_sg_db.to_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "database security group"
  }
}

# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
    name="db-secure-subnets"
    subnet_ids = [var.secure_subnet_az1_id,var.secure_subnet_az2_id]
    description  = "rds in secure subnet"
    
    tags   = {
    Name = "db-secure-subnets"
  }
}

# create the rds instance
resource "aws_db_instance" "database_instance" {
  allocated_storage       = var.aws_db_instance_details.allocated_storage
  engine                  = var.aws_db_instance_details.engine
  engine_version          = var.aws_db_instance_details.engine_version
  instance_class          = var.aws_db_instance_details.instance_class
  identifier              = var.aws_db_instance_details.identifier
  db_name                 = var.aws_db_instance_details.db_name
  username                = var.aws_db_instance_details.db_username
  password                = var.aws_db_instance_details.db_password
  multi_az                = false
  publicly_accessible     = true
  skip_final_snapshot     = true
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.id
  #port                   = var.port
  #parameter_group_name    = var.parameter_group_name
  #storage_type            = var.storage_type
  #backup_retention_period = var.backup_retention_period
  #deletion_protection     = var.deletion_protection
  #tags                    = var.tags
}

 