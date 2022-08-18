#DB Security Group and Subnet group
resource "aws_security_group" "wp_db_client_sg" {
  name = "wp-db-client-sg"

  description = "Allows wordpress servers to contact Aurora DB on 3306"
  vpc_id = var.vpc_id

  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wp-db-client-sg"
  }
}

resource "aws_security_group" "wp_db_sg" {
  name = "wp-db-sg"

  description = "Allow TCP connection on 3306 for Aurora DB"
  vpc_id      = var.vpc_id

  # Only MySQL in
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.wp_db_client_sg.id]
  }

   egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.wp_db_client_sg.id]

  }

  tags = {
    Name        = "wp-db-sg"
  }
}

resource "aws_db_subnet_group" "wp_mysql" {
  name        = "wp-mysql-subnetgroup"
  subnet_ids  = var.intra_subnets
  description = "Subnet group used for Aurora DB"

  tags = {
     Name      = "wp-mysql-subnetgroup"
  }
}

#Aurora
resource "aws_rds_cluster" "wp_db_cluster" {
  cluster_identifier     = "wp-db-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.07.8"
  availability_zones     = ["eu-west-1a", "eu-west-1b"]
  database_name          = var.cluster_dbname
  db_subnet_group_name   = aws_db_subnet_group.wp_mysql.name
  master_username        = var.cluster_username
  master_password        = var.cluster_password
  vpc_security_group_ids = [aws_security_group.wp_db_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "wp-db-cluster"
  }
}

#Aurora Instance
resource "aws_rds_cluster_instance" "wp-db-instance" {
  count                = var.db_instance_count
  identifier           = "wp-db-instance-${count.index}"
  db_subnet_group_name = aws_db_subnet_group.wp_mysql.name
  cluster_identifier   = aws_rds_cluster.wp_db_cluster.id
  instance_class       = "db.r5.large"
  engine               = aws_rds_cluster.wp_db_cluster.engine
  engine_version       = aws_rds_cluster.wp_db_cluster.engine_version
  tags = {
    Name = "wp-db-cluster-instance"
  }
}