output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.noteit_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value = [
    aws_subnet.noteit_public_subnet_a.id,
    aws_subnet.noteit_public_subnet_b.id,
  ]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value = [
    aws_subnet.noteit_private_subnet_a.id,
    aws_subnet.noteit_private_subnet_b.id,
  ]
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.noteit_nat.id
}
