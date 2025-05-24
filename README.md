# 🗳️ Flask Voting App

A lightweight web application built with **Flask** and **MySQL**, deployed on AWS using **Terraform**. Users can vote between two options ("True" or "False"), and their vote is persisted in a MySQL database hosted on Amazon RDS.

---

## 📦 Features

- ✅ Web frontend built with Flask & Jinja2
- ✅ Vote persistence in MySQL via Amazon RDS
- ✅ Environment variables for secure credentials
- ✅ Infrastructure as Code with Terraform (VPC, RDS, EC2)
- ✅ Cookie-based vote tracking (one vote per user)

---

## 🚀 Quick Start

### 🧑‍💻 1. Clone the Repo
git clone https://github.com/manuelputzu/flask-voting-app.git
cd flask-voting-app

📦 2. Set Up Python Environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

🔐 3. Create a .env File
DB_HOST=your-rds-endpoint
DB_NAME=votes
DB_USER=your-db-username
DB_PASS=your-db-password
Note: This file is excluded from Git via .gitignore.

🌐 Run the App Locally
python app.py
Visit http://localhost:5000 in your browser.

☁️ Infrastructure: Terraform on AWS
🔧 Terraform Setup
In the terraform/ directory:

cd terraform
terraform init
terraform apply
This will create:
- VPC with 2 subnets
- Security group for HTTP, SSH, MySQL
- RDS MySQL instance
- EC2 instance that auto-deploys the app via user_data

Requires AWS CLI credentials to be set up beforehand.

🔒 Security Notes
- Secrets are managed via environment variables (.env)
- Terraform state is ignored from Git; use an S3 backend for team collaboration
- .DS_Store, .env, .venv, .terraform/, and other unwanted files are excluded

🧪 Future Improvements
✅ Add unit tests with pytest

⏳ CI/CD pipeline (GitHub Actions)

⏳ HTTPS support via NGINX on EC2

⏳ Docker containerization

⏳ Use of Terraform remote backend (S3 + DynamoDB)

🧑‍🏫 Author
Manuel Putzu
LinkedIn
GitHub

📄 License
This project is licensed under the MIT License.
