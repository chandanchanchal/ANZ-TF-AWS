# VPC variable
variable "vpc-cidr" {
   default = "10.0.0.0/16"
}
# Subnets variable
variable "vpc-subnets" {
    default = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
}

locals{
   inbound_ports = [80,443]
   outbound_ports = [443,1433]
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc-cidr
}

resource "aws_subnet" "main-subnet" {
    for_each = toset(var.vpc-subnets) 
    cidr_block = each.value
    vpc_id     = aws_vpc.vpc.id
}

# Security Groups
resource "aws_security_group" "sg-webserver" {
    vpc_id              = aws_vpc.vpc.id
    name                = "webserver"
    description         = "Security Group for Web Servers"

    dynamic "ingress" {
        for_each = locals.inbound_ports
        content {
          from_port  = ingress.value
          to_port    = ingress.value
          protocol   = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        
        }
   dynamic "egress" {
        for_each = locals.outbound_ports
        content {
          from_port  = egress.value
          to_port    = egress.value
          protocol   = "tcp"
          cidr_blocks = [var.vpc-cidr]
        
        }

    }
