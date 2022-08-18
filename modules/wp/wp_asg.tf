resource "aws_security_group" "wp_node_sg" {
  name = "wp-node-sg"

  description = "Allow HTTP, HTTPS and SSH connection from Load Balancer & Bastion"
  vpc_id      = var.vpc_id

  # Only lb in http & https
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.wp_sg_http.id]
  }
  
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups = [aws_security_group.wp_sg_http.id]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [module.bastion.security_group_id]
  }
    egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp-node-sg"
  }
}

resource "aws_key_pair" "ec2key" {
  key_name   = "ec2key"
  public_key = file(var.public_key_path)
}
#Auto scaling

resource "aws_launch_configuration" "wp_launch_conf" {

  name_prefix     = "wp-launch-conf-worker"
  image_id        = data.aws_ami.server_ami.id

  instance_type   = var.instance_type
  security_groups = [aws_security_group.wp_node_sg.id]
  key_name = aws_key_pair.ec2key.key_name
  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_autoscaling_group" "wp_asg_group" {
  name                 = "${aws_launch_configuration.wp_launch_conf.name}-asg"
  launch_configuration = aws_launch_configuration.wp_launch_conf.name
  min_size             = 2
  max_size             = 8
  vpc_zone_identifier  = var.private_subnets
  target_group_arns    = [aws_alb_target_group.wp_lb_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "wp_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wp_asg_group.id
  alb_target_group_arn = aws_alb_target_group.wp_lb_tg.arn
}

# Bastion
module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix    = "wp"
  ami_id         = data.aws_ami.server_ami.id
  vpc_id         = var.vpc_id
  public_subnets = var.public_subnets

  ssh_key_name   = aws_key_pair.ec2key.key_name

  bastion_instance_types= [var.instance_type]

  tags = {
    Name = "wp-bastion"
  }
}

resource "aws_security_group" "wp_sg_http" {
  name = "wp-sg-http"
  vpc_id = var.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
     Name = "wp-sg-http"
  }

}

resource "aws_alb" "wp_lb" {

  name               = "wp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wp_sg_http.id]
  subnets            = var.public_subnets
  tags = {
      Name = "wp-lb"
    }
}

resource "aws_alb_listener" "wp_lb_listener" {
  load_balancer_arn = aws_alb.wp_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wp_lb_tg.arn
  }
}

resource "aws_alb_target_group" "wp_lb_tg" {
  name     = "wp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    port                = 80 
  }
  tags = {
    Name = "wp-tg"
    }
}
