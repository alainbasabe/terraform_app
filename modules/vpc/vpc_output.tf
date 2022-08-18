output "vpc_id" {
  description = "VPC's ID."
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The name of the VPC."
  value       = module.vpc.name
}

output "public_subnets" {
  description = "Public subnet's ids."
  value       = module.vpc.public_subnets
}

output "intra_subnets" {
  description = "Intra subnets ids."
  value       = module.vpc.intra_subnets
}

output "private_subnets" {
  description = "Private subnets ids"
  value       = module.vpc.private_subnets
}
