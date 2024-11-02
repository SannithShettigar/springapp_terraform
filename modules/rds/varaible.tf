variable "vpc_id" {}
variable "secure_subnet_az1_id" {}
variable "secure_subnet_az2_id" {}
variable "alb_security_group_id" {}


#Security Group of inbound rules for Database 
variable "ingress_sg_db" {
  type=list(object({
     from_port = number
     to_port = number
     protocol = string
  }))
}

#Security Group of outbound rules for Database 
variable "egress_sg_db" {
  type=list(object({
     from_port = number
     to_port = number
  }))
}


#RDS db credintials and details
variable "aws_db_instance_details" {
  type=list(object({
  allocated_storage       = string
  engine                  = string
  engine_version          = string
  instance_class          = string
  identifier              = string
  db_name                 = string
  db_username             = string
  db_password             = string
  }))
}


