# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  tags = {
    Name = "${var.project_name}-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.project_name}-tg"
  target_type = "instance"
  port     = each.value.lb_tg_port_portocol.port
  protocol = each.value.lb_tg_port_portocol.protocol
  #protocol_version = each.value.lb_target_group_protocol_version
  vpc_id   = var.vpc_id
  
  health_check {
    enabled = true
    healthy_threshold   = each.value.lb_tg_port_portocol.healthy_threshold
    unhealthy_threshold = each.value.lb_tg_port_portocol.unhealthy_threshold
    timeout             = each.value.lb_tg_port_portocol.timeout
    interval            = each.value.lb_tg_port_portocol.interval
    path                = "/"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.lb_http_listener.port
  protocol          = var.lb_http_listener.protocol
  default_action {
    type = var.listener_redirect_action.type
    redirect {
      port        = var.listener_redirect_action.port
      protocol    = var.listener_redirect_action.protocol
      status_code = var.listener_redirect_action.status_code
    }
  }
}