resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.main_1a.id, aws_subnet.main_1b.id]
}

resource "aws_db_instance" "votes_db" {
  identifier              = "votes-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "votes_db"
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.db.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  skip_final_snapshot     = true
  publicly_accessible     = false
}