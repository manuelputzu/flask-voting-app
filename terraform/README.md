# Terraform Infrastructure for Flask Voting App

This Terraform config deploys:
- A custom VPC and subnets
- A security group for SSH, HTTP, and MySQL
- An RDS MySQL instance
- An EC2 instance that installs Docker and runs the Flask app

## Usage

```bash
cd terraform
terraform init
terraform apply
