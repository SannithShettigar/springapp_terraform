# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name = "ec2/alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id = var.vpc_id

  ingress {
    description = "http access"
    from_port = var.ingress_from_to_port.from_port
    to_port = var.ingress_from_to_port.to_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = var.egress_from_to_port.from_port
    to_port = var.egress_from_to_port.to_port
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags   = {
    Name = "ec2/alb security group"
  }
  
}