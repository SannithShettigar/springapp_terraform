variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
variable "secure_subnet_az1_cidr" {}
variable "secure_subnet_az2_cidr" {}

# SG - Ingress Global Variables 
variable "ingress_from_to_port" {
type=list(object(
        {
            from_port = number
            to_port= number
        }
    ))
}

# SG - Ingress Global Variables 
variable "egress_from_to_port" {
    type=list(object(
        {
            from_port = number
            to_port= number
        }
    ))
}

# ALB Target group and health check Global Variables 
variable "lb_tg_port_portocol" {
    type = list(string)
}
variable "lb_tg_health_check"{
    type = list(string)
}


# Listerner http Global Variables.tf
variable "lb_http_listener"{
    type=list(object(
    {
      port = string
      protocol = string
    }))
}

# Listerner http redirect actions Global Variables.tf
variable "listener_redirect_action" {
  type=object({
    type = string
    redirect = {
      port = string
      protocol = string
      status_code = string
    }
  })
}

# Aws Launch template of EC2 Instances type Global Variables.tf
variable "launch_template_ec2_instance_type" {
  type = list(string)
}

#ASG launching the EC2 instance based on the traffic Global Variables.tf
variable "asg_launch_ec2_instance" {
type=list(object({
  min_size            = number
  max_size            = number
  desired_capacity    = number
}))
}

# EC2 module for VPC Endpoints Security group allowed inbound https traffic Global Variables.tf
variable "ingress_https_sg" {
  type=list(object({
     from_port = number
     to_port = number
     protocol = string
  }))
}

#Security Group of inbound rules for Database - Global Variables.tf
variable "ingress_sg_db" {
  type=list(object({
     from_port = number
     to_port = number
     protocol = string
  }))
}

#Security Group of outbound rules for Database -Global Variables.tf
variable "egress_sg_db" {
  type=list(object({
     from_port = number
     to_port = number
  }))
}


#RDS db credintials and details - Global Variables.tf
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