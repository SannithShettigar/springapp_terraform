variable "project_name" {}
variable "alb_security_group_id" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "vpc_id" {}

variable "lb_tg_port_portocol" {
    type = list(string)
}
variable "lb_tg_health_check"{
    type = list(string)
}

variable "lb_http_listener"{
    type=list(object(
    {
      port = string
      protocol = string
    }))
}

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
