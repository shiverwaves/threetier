output "vpc_id" {
    description = "The ID of the VPC"
    value       = try(aws_vpc.vpc.id, null)
}

output "public_subnet_id" {
    description = "The ID of the Public Subnet"
    value       = try(aws_subnet.public_subnet.id, null)
}

output "public_subnet_cidr" {
    description = "The ID of the Public Subnet"
    value       = try(aws_subnet.public_subnet.cidr_block, null)
}

output "public_route_table_id" {
    description = "The ID of the Public Route Table"
    value       = try(aws_route_table.public_route_table.id, null)
}

output "private_subnet_id" {
    description = "The ID of the Private Subnet"
    value       = try(aws_subnet.private_subnet.id, null)
}

output "private_subnet_cidr" {
    description = "The ID of the Private Subnet"
    value       = try(aws_subnet.private_subnet.cidr_block, null)
}