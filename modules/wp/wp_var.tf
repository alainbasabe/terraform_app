
variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
    type         = string
    default      = "t2.micro"
    description  = "Instance type"
}

variable "public_subnets" {
    description = "Public subnets - lb"
}

variable "vpc_id" {
  description = "VPC's ID."
}

variable "intra_subnets" {
  description = "Intra subnets ids."
}

variable "private_subnets" {
  description = "Private subnets ids"
}

variable "efs_dns_name" {
  description = "EFS's DNS name"
}

variable "db_name" {
  description = "Database name"
}

variable "db_hostname" {
  description = "Database dns name"
}

variable "db_username" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
}

variable "clients_sg" {
  description = "Security group ids of data layer clients"
}
