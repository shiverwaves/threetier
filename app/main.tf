
# create public security group
resource "aws_security_group" "public_security_group" {
    vpc_id = var.vpc_id
    name        = "public_security_group"
    description = "Allow HTTP, HTTPS, SSH, inbound web server traffic"

    ingress {

        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }
    ingress {

        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }
    ingress {

        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }
    ingress {

        from_port         = 8
        to_port           = 0
        protocol          = "icmp"
        cidr_blocks       = [var.public_subnet_cidr]
    }
    egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project}-public_security_group"
        Resource = "security_group"
    }
}

# create private security group
resource "aws_security_group" "private_security_group" {
    vpc_id = var.vpc_id
    name        = "private_security_group"
    description = "Allow 3306, 5432, inbound database server traffic"

    ingress {

        from_port         = 3306
        to_port           = 3306
        protocol          = "tcp"
        cidr_blocks       = [var.public_subnet_cidr]
    }
    ingress {

        from_port         = 5432
        to_port           = 5432
        protocol          = "tcp"
        cidr_blocks       = [var.public_subnet_cidr]
    }
    ingress {

        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }
    ingress {

        from_port         = 8
        to_port           = 0
        protocol          = "icmp"
        cidr_blocks       = [var.public_subnet_cidr]
    }
    egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project}-private_security_group"
        Resource = "security_group"
    }
}

# find aws ami
data "aws_ami" "os" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# generate keypair
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# add keypair to aws
resource "aws_key_pair" "ssh_key" {
    key_name   = "${var.project}-ssh-key"
    public_key = tls_private_key.keygen.public_key_openssh
    # export ssh private key to localhost
    provisioner "local-exec" {
        command = "echo '${tls_private_key.keygen.private_key_pem}' > '/root/.ssh/${var.project}-ssh-key'"
    }
}

# create webserver ec2 instance
resource "aws_instance" "webserver_instance" {
    ami = data.aws_ami.os
    #ami = "ami-053b0d53c279acc90"
    key_name = "${var.project}-ssh-key"
    associate_public_ip_address = true
    subnet_id = var.public_subnet_id
    security_groups = [ aws_security_group.public_security_group.id ]
    tags = {
        Name = "${var.project}-webserver_ec2"
        Resource = "instance"
    }
}

# create database ec2 instance
resource "aws_instance" "database_instance" {
    ami = data.aws_ami.os
    #ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    key_name = "${var.project}-ssh-key"
    subnet_id = var.private_subnet_id
    security_groups = [ aws_security_group.private_security_group.id ]
    tags = {
        Name = "${var.project}-database_ec2"
        Resource = "instance"
    }
}

# create ssh config on localhost
resource "local_file" "ssh_config" {
  filename = "/root/.ssh/config"
  content = <<-EOT
host webserver_ec2
    HostName ${aws_instance.webserver_instance.public_ip}
    User ubuntu
    StrictHostKeyChecking no
    IdentityFile /root/.ssh/${var.project}-ssh-key

host database_ec2
    HostName ${aws_instance.database_instance.private_ip}
    User ubuntu
    StrictHostKeyChecking no
    ProxyCommand ssh webserver_ec2 -W %h:%p
    IdentityFile /root/.ssh/${var.project}-ssh-key
EOT
    # change permisions of ssh files
    provisioner "local-exec" {
        command = "chmod 600 /root/.ssh/'${var.project}-ssh-key'"
    }
}

# create alb
# alb sg