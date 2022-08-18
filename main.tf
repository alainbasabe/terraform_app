module "vpc" {
  source                 = "./modules/vpc"
}

module "db" {
  source                = "./modules/db"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  public_subnets        = module.vpc.public_subnets
  intra_subnets         = module.vpc.intra_subnets
}

module "wp" {
  #Wait until Aurora is deployed
  depends_on = [
    module.db,
    module.vpc
  ]
  source                 = "./modules/wp"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  public_subnets        = module.vpc.public_subnets
  intra_subnets         = module.vpc.intra_subnets  
  
  efs_dns_name          = module.db.efs_dns_name
  db_name               = module.db.db_name
  db_hostname           = module.db.db_hostname
  db_username           = module.db.db_username  
  db_password           = module.db.db_password
  clients_sg            = module.db.clients_sg

}

output "load_balancer_dns" {
  value = module.wp.alb_dns
}


