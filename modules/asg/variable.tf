variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
variable "application_load_balancer" {}
variable "alb_target_group_arn" {}
variable "alb_security_group_id" {}
variable "iam_ec2_instance_profile" {}
variable "project_name" {}
variable "rds_db_endpoint" {}


variable "launch_template_ec2_instance_type" {
  type = list(string)
}
variable "asg_launch_ec2_instance" {
type=list(object({
  min_size            = number
  max_size            = number
  desired_capacity    = number
}))
}



