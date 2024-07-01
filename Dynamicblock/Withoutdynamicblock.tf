# VPC variable
variable "vpc-cidr" {
   default = "10.0.0.0/16"
}
# Subnets variable
variable "vpc-subnets" {
    default = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
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
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = [ var.vpc-cidr ]
    }
    egress {
        protocol = "tcp"
        from_port = 1433
        to_port = 1433
        cidr_blocks = [ var.vpc-cidr ]
    }
}
