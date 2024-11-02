data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# terraform aws launch template
resource "aws_launch_template" "launch-template" {
  name                    = "my-launch-template"
  image_id                = data.aws_ami.amazon_linux_2.id
  instance_type           = each.value.launch_template_ec2_instance_type.instance_type
  iam_instance_profile {
    name = var.iam_ec2_instance_profile.name
  }
  user_data    = base64encode(templatefile(("userdata.sh"), {mysql_url=var.rds_db_endpoint}))
  vpc_security_group_ids  = [var.alb_security_group_id]
  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg-tf" {
  name = "${var.project_name}-ASG"
  min_size            = var.asg_launch_ec2_instance.min_size
  max_size            = var.asg_launch_ec2_instance.max_size
  desired_capacity    = var.asg_launch_ec2_instance.desired_capacity
  force_delete = true
  depends_on = [var.application_load_balancer]
  target_group_arns   = [var.alb_target_group_arn]
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.launch-template.id
    version = aws_launch_template.launch-template.latest_version
  }
  vpc_zone_identifier = [var.private_subnet_az1_id,var.private_subnet_az2_id]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }
}
