
locals {
 instance_type  = {
    default          = "t2.nano"
    dev              = "t2.micro"
    prod             = "t2.small"
 }

}

resource "aws_instance" "myec2" {
 ami            = "ami-01b799c439fd5516a"
 #instance_type  = local.instance_type[terraform.workspace]
 instance_type   = "t2.small"

}

resource "aws_security_group" "sg-1" {
 name = "prod_firewall"
 provider = aws.Ohio
}

resource "aws_security_group" "sg-2" {
 name = "staging_firewall"
 provider = aws.Oregon
}
