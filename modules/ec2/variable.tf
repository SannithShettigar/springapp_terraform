variable "vpc_id" {}
variable "region" {}

variable "ingress_https_sg" {
  type=list(object({
     from_port = number
     to_port = number
     protocol = string
  }))
}

