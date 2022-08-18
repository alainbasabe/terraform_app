resource "aws_security_group" "wp_efs_client_sg" {
  name = "wp-efs-client-sg"

  description = "Allow wordpress servers to connect to EFS on 2049"
  vpc_id = var.vpc_id

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wp-efs-client-sg"
  }
}

resource "aws_security_group" "wp_efs_sg" {
  name = "wp-efs-sg"

  description = "Allow TCP connection on 2049  for Elastic File System"
  vpc_id      = var.vpc_id

  # Only efs in
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_efs_client_sg.id]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [aws_security_group.wp_efs_client_sg.id]
  }

  tags = {
    Name        = "wp-efs-sg"
  }
}

resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp-efs"
  encrypted      = true

  tags = {
    Name        = "wp-efs"
  }
}

resource "aws_efs_mount_target" "wp_efs_mount-targets" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.wp_efs_sg.id]
}