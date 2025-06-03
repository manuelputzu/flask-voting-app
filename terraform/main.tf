resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "main-vpc" }
}

# two subnets in different AZs minimum
resource "aws_subnet" "main_1a" { 
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "main_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main_1a" {
  subnet_id      = aws_subnet.main_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main_1b" {
  subnet_id      = aws_subnet.main_1b.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_web_mysql" {
  name        = "allow_web_mysql"
  description = "Allow web and MySQL traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # SSH access - restrict in production
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # MySQL - restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "votes_db" {
  identifier              = "votes-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "votes_db"
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.allow_web_mysql.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  skip_final_snapshot     = true
  publicly_accessible     = false
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.main_1a.id, aws_subnet.main_1b.id]
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_1a.id
  vpc_security_group_ids = [aws_security_group.allow_web_mysql.id]
  key_name      = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io git

              exec > /var/log/user-data.log 2>&1
              set -x
              mkdir -p /home/ubuntu
              chown ubuntu:ubuntu /home/ubuntu

              systemctl start docker
              systemctl enable docker

              cd /home/ubuntu
              git clone https://github.com/manuelputzu/flask-voting-app.git

              # Create .env file with DB credentials
              cat <<EOT > /home/ubuntu/flask-voting-app/.env
              DB_HOST=${aws_db_instance.votes_db.endpoint}
              DB_NAME=votes_db
              DB_USER=${var.db_username}
              DB_PASS=${var.db_password}
              EOT

              # Run Docker container with .env file
              docker pull mputzu/flask-voting-app:latest
              /usr/bin/docker run -d --env-file /home/ubuntu/flask-voting-app/.env -p 5000:5000 mputzu/flask-voting-app:latest
              EOF

  tags = {
    Name = "FlaskVotingApp"
  }
}
