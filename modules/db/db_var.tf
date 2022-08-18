variable "cluster_dbname" {
    type         = string
    default      = "wordpress"
    description  = "RDS cluster database name"
}

variable "cluster_username" {
    type         = string
    default      = "username"
    description  = "Database cluster username"
}

variable "cluster_password" {
    type         = string
    default      = "password"
    description  = "Database cluster password"
}

variable "db_instance_count" {
    type         = number
    default      = 2
    description  = "Number of db instances, same as the number of azs"
}

variable "memcached_node_type" {
    type         = string
    default      = "cache.t2.small"
    description  = "Elasticache cluster's node type"
}

variable "memcached_num_cache_nodes" {
    type         = number
    default      = 1
    description  = "Number of cache nodes"
}

variable "efs_dns_name" {
  description = "EFS's DNS name"
  default = "wp-efs"
}

variable "db_name" {
  description = "Database name"
  default = "wpdb"
}

variable "db_hostname" {
  description = "Database dns name"
  default = "wp-node"
}

variable "db_username" {
  description = "Database username"
  default = "alain"
}

variable "db_password" {
  description = "Database password"
  sensitive = true
  default = "Al41n98!"
}

variable "intra_subnets" {
    description = "Intra subnets - Database"
}

variable "private_subnets" {
    description = "Private subnets -application servers"
}

variable "vpc_id" {
  description = "VPC's ID."
}

variable "public_subnets" {
  description = "Public subnet's ids."
}