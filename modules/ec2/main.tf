# Security group for VPC Endpoints

resource "aws_security_group" "vpc_endpoint_security_group_allow_inbound" {
    name = "vpc_endpoint_security_group"
    vpc_id = var.vpc_id
    description = "Allow inbound HTTPS traffic"
    
# Allow inbound HTTPS traffic
ingress {
        description = "HTTPS"
        from_port = var.ingress_https_sg.from_port
        to_port = var.ingress_https_sg.to_port
        protocol = var.ingress_https_sg.protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
  
        tags = {
           Name = "VPC Endpoint security group"
         }
}

locals {
  endpoints = {
    "endpoint-ssm" = {
      name = "ssm"
    },
    "endpoint-ssmm-essages" = {
      name = "ssmmessages"
    },
    "endpoint-ec2-messages" = {
      name = "ec2messages"
    }
  }
}

resource "aws_vpc_endpoint" "endpoints" {
   vpc_id              = var.vpc_id
   for_each = local.endpoints
   vpc_endpoint_type   = "Interface"
   service_name        = "com.amazonaws.${var.region}.${each.value.name}"
   #private_dns_enabled = true
  
  # Add a security group to the VPC endpoint
   security_group_ids  = [aws_security_group.vpc_endpoint_security_group_allow_inbound.id]

  tags = {
    Name = "VPC Endpoint for ${each.value.name}"
  }
}
  
# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name="EC2_SSM_Role"
  assume_role_policy = jsondecode(
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
})
}   

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_role.name
}


# Create an instance profile for the EC2 instance and associate the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2_SSM_Instance_Profile"
  role = aws_iam_role.ec2_role.name
}
