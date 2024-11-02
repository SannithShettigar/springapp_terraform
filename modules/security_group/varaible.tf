variable "vpc_id" {}

variable "ingress_from_to_port" {
type=list(object(
        {
            from_port = number
            to_port= number
        }
    ))
}

variable "egress_from_to_port" {
    type=list(object(
        {
            from_port = number
            to_port= number
        }
    ))
}
