resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# two subnets in different AZs minimum
resource "aws_subnet" "main_1a" { 
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "main_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-central-1b"
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
    cidr_blocks = ["0.0.0.0/0"] # SSH access - restrict in production
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
  publicly_accessible     = true
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

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install python3-pip -y
              pip3 install flask mysql-connector-python flask_sqlalchemy
              git clone https://github.com/manuelputzu/flask-voting-app.git
              cd voting-web-app-light
              python3 app.py
              EOF

  tags = {
    Name = "FlaskVotingApp"
  }
}
