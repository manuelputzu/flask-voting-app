resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_1a.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    set -x

    apt update -y
    apt install -y docker.io git

    systemctl start docker
    systemctl enable docker

    mkdir -p /home/ubuntu
    chown ubuntu:ubuntu /home/ubuntu
    cd /home/ubuntu

    git clone https://github.com/manuelputzu/flask-voting-app.git

    # Create .env file with DB credentials
    cat <<EOT > /home/ubuntu/flask-voting-app/.env
    DB_HOST=${aws_db_instance.votes_db.endpoint}
    DB_NAME=votes_db
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    DB_PORT=3306
    EOT

    docker pull mputzu/flask-voting-app:latest
    /usr/bin/docker run -d --env-file /home/ubuntu/flask-voting-app/.env -p 5000:5000 mputzu/flask-voting-app:latest
  EOF

  tags = {
    Name = "FlaskVotingApp"
  }
} 
