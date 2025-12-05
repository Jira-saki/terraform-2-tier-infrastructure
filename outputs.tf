# outputs.tf

output "web_public_ip" {
  description = "Public IP of the Web Server"
  value       = aws_instance.web.public_ip
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database"
  value       = aws_db_instance.default.address
}
