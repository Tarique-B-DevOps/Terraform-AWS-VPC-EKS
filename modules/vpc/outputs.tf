output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.private_network.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = var.provision_nat_gateway ? aws_nat_gateway.nat[0].id : null
}
