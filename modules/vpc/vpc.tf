module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "wp-vpc"
  cidr = "10.0.0.0/16"
  azs = var.azs

  # app servers subnets
  private_subnets = var.private_subnets
  # db subnets
  intra_subnets = var.intra_subnets
  # Load balancer subnets
  public_subnets  = var.public_subnets

  enable_vpn_gateway = true

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  #enable dns resolution support
  enable_dns_hostnames = true
  enable_dns_support   = true

}