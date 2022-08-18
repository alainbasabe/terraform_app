resource "aws_security_group" "wp_memcached_client_sg" {
  name = "wp-memcached-client-sg"

  description = "Allow wordpress servers to contact elasticache on 11211"
  vpc_id = var.vpc_id

  egress {
    from_port = 11211
    to_port   = 11211
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wp-memcached-client-sg"
  }
}

resource "aws_security_group" "wp_memcached_sg" {
  name = "wp-memcached-sg"

  description = "Allow TCP connection on 11211 for Elasticache"
  vpc_id      = var.vpc_id

  # Only cache in
  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_memcached_client_sg.id]
  }

   egress {
    from_port = 11211
    to_port   = 11211
    protocol  = "tcp"

    security_groups = [aws_security_group.wp_memcached_client_sg.id]
  }

    tags = {
    Name        = "wp-memcached-sg"
  }
}

resource "aws_elasticache_cluster" "wp_memcached_cluster" {
  cluster_id           = "wp-memcached-cluster"
  engine_version       = "1.5.16"
  subnet_group_name    = aws_elasticache_subnet_group.wp_memcached_subnet.name
  security_group_ids   = [aws_security_group.wp_memcached_sg.id]
  engine               = "memcached"
  node_type            = var.memcached_node_type
  num_cache_nodes      = var.memcached_num_cache_nodes
  parameter_group_name = "default.memcached1.5"
  port                 = 11211

  tags = {
    Name        = "wp-memcached-cluster"
  }
}

resource "aws_elasticache_subnet_group" "wp_memcached_subnet" {
  name        = "wp-memcached-subnet"
  description = "Subnet group used by elasticache"
  subnet_ids  = var.intra_subnets

  tags = {
    Name        = "wp-memcached-subnet"
  }
}