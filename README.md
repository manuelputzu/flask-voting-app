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

🔐 3. Before running the app, copy .env.example to .env and fill in your real database credentials:
cp .env.example .env

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

☸️ Kubernetes Deployment (Minikube)
You can now run the Flask Voting App on a local Kubernetes cluster!

🧱 Requirements
- [Docker](https://www.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

📦 Build and Deploy on Minikube
# Start minikube
minikube start

# Use minikube's Docker engine
eval $(minikube docker-env)

# Build your image locally
docker build -t flask-voting-app .

# Create Kubernetes secrets
kubectl create secret generic db-secret \
  --from-literal=DB_USER=root \
  --from-literal=DB_PASS=yourpassword

# Apply Kubernetes manifests
kubectl apply -f k8s/

🔁 Access the App
kubectl get pods
kubectl port-forward pod/<your-flask-pod-name> 5000:5000
Then visit: http://localhost:5000

🧪 Future Improvements
✅ Add unit tests with pytest

✅ CI/CD pipeline (GitHub Actions)

⏳ HTTPS support via NGINX on EC2

✅ Docker containerization

⏳ Use of Terraform remote backend (S3 + DynamoDB)

⏳ Future: Kubernetes on AWS (EKS) or K3s on EC2



🧑‍🏫 Author
Manuel Putzu
LinkedIn
GitHub

📄 License
This project is licensed under the MIT License.
