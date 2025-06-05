output "web_instance_public_ip" {
  description = "Public IP of the EC2 instance running the Flask app"
  value = aws_instance.web.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.votes_db.endpoint
}
