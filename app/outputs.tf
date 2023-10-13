output "public_security_group_id" {
    description = "The ID of the Public Subnet Security Group"
    value       = try(aws_security_group.public_security_group.id, null)
}

output "private_security_group_id" {
    description = "The ID of the Private Subnet Security Group"
    value       = try(aws_security_group.private_security_group.id, null)
}

output "webserver_public_ip" {
    description = "The Public IP of the Webserver EC2 Instance"
    value       = try(aws_instance.webserver_instance.public_ip, null)
}

output "database_private_ip" {
    description = "The Private IP of the Database EC2 Instance"
    value       = try(aws_instance.database_instance.private_ip, null)
}