# Terraform Infrastructure for Flask Voting App

This Terraform config deploys:
- A custom VPC and subnets
- A security group for SSH, HTTP, and MySQL
- An RDS MySQL instance
- An EC2 instance that installs Docker and runs the Flask app

## Usage

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars  # Fill in your real values
terraform init
terraform apply

## Outputs

After `terraform apply`, you’ll see:

- EC2 Public IP → Visit `http://<public-ip>:5000`
- RDS endpoint → Used automatically in the app via `.env`

You can re-run:

```bash
terraform output
