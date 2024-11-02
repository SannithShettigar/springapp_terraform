region="us-east-1"
project_name="awsinfra"
vpc_cidr="172.16.0.0/16"
public_subnet_az1_cidr="172.16.0.0/20"
public_subnet_az2_cidr="172.16.16.0/20"
private_subnet_az1_cidr="172.16.128.0/20"
private_subnet_az2_cidr="172.16.144.0/20"
secure_subnet_az1_cidr="172.16.160.0/20"
secure_subnet_az2_cidr="172.16.176.0/20"

# SG - Ingress Global Variables tfvars
ingress_from_to_port=[
{
        from_port= 80
        to_port= 80
},
{
    from_port=443
    to_port=443
}
]

#SG - Egress Global Variables tfvars
egress_from_to_port=[
{
     from_port=0
     to_port=0
}
]

# ALB Target group and health check Global Variables tfvars
lb_tg_port_portocol=[
  {
    port=80
    protocol="HTTP"

  }
] 

lb_tg_health_check =[
{
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 60
    interval            = 300
}
]

# Listerner http Global Variables tfvars
 lb_http_listener =[
    {
        port="80"
        portocol="HTTP"
    }
 ]

 # Listerner http redirect actions Global Variables tfvars

 listener_redirect_action=[
    {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
 ]

# Aws Launch template of EC2 Instances type
launch_template_ec2_instance_type=[
{
    instance_type =["t2.micro"]
}
]

#ASG launching the EC2 instance based on the traffic
asg_launch_ec2_instance=[
  {
    min_size            = 1
    max_size            = 2
    desired_capacity    = 2
  }
]

     
# EC2 module for VPC Endpoints Security group allowed inbound https traffic
ingress_https_sg=[
  {
     from_port = 443
     to_port = 443
     protocol = "tcp"
  }
]

#Security Group of inbound rules for Database 
ingress_sg_db=[
  {
     from_port = 3306
     to_port =   3306
  }
]

#Security Group of outbound rules for Database 
egress_sg_db=[
  {
     from_port = 0
     to_port = 0
  }
]

#RDS Databse Instances Details
aws_db_instance_details=[
  {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0.31"
  instance_class          = "db.t2.micro"
  identifier              = "petclinic"
  db_name                 = "petclinic"
  }
]
  