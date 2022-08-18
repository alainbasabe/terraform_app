output "alb_dns" {
  value  = aws_alb.wp_lb.dns_name
}