variable "azs" {
    type        = list(string)
    default     = ["eu-west-1a", "eu-west-1b"]
    description = "Availability zones"
}

variable "private_subnets" {
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
    description = "Private subnets - worpress servers"
}
variable "public_subnets" {
    type        = list(string)
    default     = ["10.0.101.0/24", "10.0.102.0/24"]
    description = "Public subnets - lb"
}
variable "intra_subnets" {
    type        = list(string)
    default     = ["10.0.5.0/24", "10.0.6.0/24"]
    description = "Intra subnets - Database"
}