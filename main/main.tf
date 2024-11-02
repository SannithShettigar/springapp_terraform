provider "Aws" {
  region = var.region
}

# create vpc
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  secure_subnet_az1_cidr       = var.secure_subnet_az1_cidr
  secure_subnet_az2_cidr       = var.secure_subnet_az2_cidr
}

# create nat gateway
module "natgateway" {
  source = "../modules/natgateway"
  internet_gateway_id            = module.vpc.internet_gateway_id
  public_subnet_az1_id           = module.vpc.public_subnet_az1_id
  public_subnet_az2_id           = module.vpc.public_subnet_az2_id
  vpc_id                         = module.vpc.vpc_id
  private_subnet_az1_id          = module.vpc.private_subnet_az1_id
  private_subnet_az2_id          = module.vpc.private_subnet_az2_id
}

# create security group
module "securitygroup" {
  source                       = "../modules/securitygroup"
  vpc_id                       = module.vpc.vpc_id
  ingress_from_to_port         = module.ingress_from_to_port
  egress_from_to_port          = module.egress_from_to_port
}


# create alb
module "alb" {
  source                      = "../modules/alb"
  project_name                = var.project_name
  alb_security_group_id       = module.securitygroup.alb_security_group_id
  public_subnet_az1_id        = module.vpc.public_subnet_az1_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  vpc_id                      = module.vpc.vpc_id
  lb_tg_port_portocol         = module.lb_tg_port_portocol
  b_tg_health_check           = module.b_tg_health_check
  lb_http_listener            = module.lb_http_listener
  listener_redirect_action    = module.listener_redirect_action
}


# create ec2
module "ec2" {
  source                                 = "../modules/ec2"
  vpc_id                                 = module.vpc.vpc_id
  region                                 = module.region
  ingress_https_sg                       = module.ingress_https_sg
}

#create rds
module "rds" {
  source                             = "../modules/rds"
  vpc_id                             = module.vpc.vpc_id
  alb_security_group_id              = module.security_group.alb_security_group_id
  secure_subnet_az1_id               = module.vpc.secure_subnet_az1_id
  secure_subnet_az2_id               = module.vpc.secure_subnet_az2_id
  ingress_sg_db                      = module.ingress_sg_db
  egress_sg_db                       = module.egress_sg_db
  aws_db_instance_details            = module.aws_db_instance_details
}


# create ASG
module "asg" {
  source = "../modules/asg"
  project_name                      = module.project_name
  rds_db_endpoint                   = module.rds_db_endpoint
  iam_ec2_instance_profil           = module.iam_ec2_instance_profil
  lb_security_group_id              = module.alb_security_group_id
  alb_target_group_arn              = module.alb_target_group_arn
  application_load_balancer         = module.application_load_balancer
  private_subnet_az1_id             = module.private_app_subnet_az1_cidr
  private_subnet_az2_id             = module.private_app_subnet_az2_id
  launch_template_ec2_instance_type = module.launch_template_ec2_instance_type
  asg_launch_ec2_instance           = module.asg_launch_ec2_instance
}











