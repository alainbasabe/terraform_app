data "template_file" "user_data" {
  template = file("user_data.tpl")
  vars = {
    EFS_MOUNT   = var.efs_dns_name
    DB_NAME     = var.db_name
    DB_HOSTNAME = var.db_hostname
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    LB_HOSTNAME = aws_alb.wp_lb.dns_name
  }
}

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}