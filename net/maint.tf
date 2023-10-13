# create aws_vpc
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "${var.project}-vpc"
        Resource = "vpcs"
    }
}

# create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = try(aws_vpc.vpc.id, null)
    cidr_block = var.public_cidr
    tags = {
        Name = "${var.project}-public_subnet"
        Resource = "subnets"
    }
}

# create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = try(aws_vpc.vpc.id, null)
    tags = {
        Name = "${var.project}-internet_gateway"
        Resource = "internet_gateway"
    }
}

# create public route table with default route to the internet gateway
resource "aws_route_table" "public_route_table" {
    vpc_id = try(aws_vpc.vpc.id, null)

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = try(aws_internet_gateway.internet_gateway.id)
    }

    tags = {
        Name = "${var.project}-public_route_table"
        Resource = "route_table"
    }
}

# create a public subnet association with the public route table
resource "aws_route_table_association" "public_route_table_association" {
    subnet_id      = try(aws_subnet.public_subnet.id)
    route_table_id = try(aws_route_table.public_route_table.id)
}

# create private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = try(aws_vpc.vpc.id, null)
    cidr_block = var.private_cidr
    tags = {
        Name = "${var.project}-private_subnet"
        Resource = "subnets"
    }
}