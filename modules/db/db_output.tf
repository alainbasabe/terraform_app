output "efs_dns_name" {
  description = "EFS's DNS name"
  value       = aws_efs_mount_target.wp_efs_mount-targets[0].dns_name
}

output "db_name" {
  description = "Database name"
  value       = aws_rds_cluster.wp_db_cluster.database_name
}

output "db_hostname" {
  description = "Database dns name"
  value       = aws_rds_cluster.wp_db_cluster.endpoint
}

output "db_username" {
  description = "Database username"
  value       = aws_rds_cluster.wp_db_cluster.master_username
}

output "db_password" {
  description = "Database password"
  value       = aws_rds_cluster.wp_db_cluster.master_password
}

output "clients_sg" {
  description = "Security group ids of data layer clients"
  value = [
    aws_security_group.wp_db_client_sg.id, 
    aws_security_group.wp_memcached_sg.id,
    aws_security_group.wp_efs_client_sg.id
  ]
}