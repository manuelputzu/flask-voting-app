# 🗳️ Flask Voting App

A lightweight web application built with **Flask** and **MySQL**, deployed on AWS using **Terraform**. Users can vote between two options ("True" or "False"), and their vote is stored in a MySQL database hosted on Amazon RDS.

---

## 📦 Features

- ✅ Web frontend built with Flask & Jinja2  
- ✅ Vote persistence using Amazon RDS (MySQL)  
- ✅ Cookie-based vote tracking (one vote per user)  
- ✅ Secure configuration via environment variables  
- ✅ Infrastructure as Code using Terraform (VPC, RDS, EC2)  
- ✅ GitHub Actions workflow for EC2-based backup deployment  
- ✅ Kubernetes-ready: deploy locally with Minikube  

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/manuelputzu/flask-voting-app.git
cd flask-voting-app
```

### 2. Set Up Python Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3. Configure Environment Variables

Copy the example file and edit with your real database credentials:

```bash
cp .env.example .env
```

### 4. Run the App Locally

```bash
python app.py
```

Then visit: [http://localhost:5000](http://localhost:5000)

---

## ☁️ Infrastructure on AWS with Terraform

All infrastructure can be deployed via Terraform in the `terraform/` folder.

### Prerequisites

- AWS CLI installed and authenticated (`aws configure`)
- A valid key pair in AWS EC2
- Secrets configured if using GitHub Actions

### Manual Terraform Setup

```bash
cd terraform
terraform init
terraform apply
```

# Set secrets for GitHub Actions in your repo
# Then run manually or via `terraform apply` for local deployment.

This will provision:

- A VPC with two subnets in different AZs  
- Security Group allowing HTTP, SSH, and MySQL  
- A public MySQL RDS instance  
- An EC2 instance with the app auto-deployed via `user_data`  

> ⚠️ Terraform expects a `terraform.tfvars` file (not included for security). Use `terraform.tfvars.example` as a reference.

---

## 🤖 GitHub Actions Deployment (Backup EC2)

The repo includes a workflow to deploy a backup EC2 instance using Terraform.

### Secure Variables via GitHub Secrets

| Secret Name              | Description                   |
|--------------------------|-------------------------------|
| `AWS_ACCESS_KEY_ID`      | AWS programmatic access key   |
| `AWS_SECRET_ACCESS_KEY`  | AWS secret access key         |
| `AMI_ID`                 | EC2 AMI ID                    |
| `EC2_KEY_NAME`           | AWS EC2 key pair name         |
| `DB_USER`                | Database username             |
| `DB_PASS`                | Database password             |

You can trigger the workflow manually under the **Actions** tab in GitHub.

---

## ☸️ Kubernetes Deployment (Local with Minikube)

You can also deploy this app in a local Kubernetes cluster.

### Requirements

- [Docker](https://www.docker.com/)  
- [Minikube](https://minikube.sigs.k8s.io/)  
- [kubectl](https://kubernetes.io/)  

### Steps

```bash
minikube start
eval $(minikube docker-env)
docker build -t flask-voting-app .

kubectl create secret generic db-secret \
  --from-literal=DB_USER=root \
  --from-literal=DB_PASS=yourpassword

kubectl apply -f k8s/
```

Then port-forward to access:

```bash
kubectl port-forward pod/<your-flask-pod-name> 5000:5000
```

Visit: [http://localhost:5000](http://localhost:5000)

---

## 🧪 Future Improvements

- ✅ Unit testing with Pytest  
- ✅ GitHub Actions CI/CD for EC2 deployment  
- ⏳ HTTPS support (NGINX or ALB on EC2)  
- ✅ Docker containerization  
- ⏳ Remote Terraform state (S3 + DynamoDB)  
- ⏳ Kubernetes deployment on AWS (EKS or K3s on EC2)  

---

## 👤 Author

**Manuel Putzu**  
[LinkedIn](https://www.linkedin.com/) • [GitHub](https://github.com/manuelputzu)

---

## 📄 License

This project is licensed under the MIT License.
