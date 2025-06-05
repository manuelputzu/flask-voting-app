output "web_public_ip" {
  value = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}

output "rds_endpoint" {
  value = aws_db_instance.votes_db.endpoint
  description = "Endpoint of the RDS instance"
}
