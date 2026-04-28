Project Overview

This project deploys a highly available Flask API application on AWS using:

VPC (Public + Private Subnets)

Application Load Balancer (ALB)

Auto Scaling Group (ASG)

Launch Template with user_data

IAM Roles & Instance Profiles

CloudWatch Logs Integration

Terraform Infrastructure-as-Code

ASG-based self-healing architecture

The application runs on EC2 instances inside private subnets and is exposed to users only through an ALB in public subnets.

Architecture Diagram

<img width="531" height="476" alt="image" src="https://github.com/user-attachments/assets/b5c73c3c-55d3-464c-8288-bd83e67d45c4" />


Project Structure

<img width="654" height="463" alt="image" src="https://github.com/user-attachments/assets/d8bc8cc9-30a4-4ad9-a2f9-1da542f0ed9e" />



How the Deployment Works


1️. Terraform provisions:

VPC

Public & Private Subnets

Route Tables

Internet Gateway

ALB + Listener + Target Group

Launch Template with injected app.py

Auto Scaling Group (min=1/max=2)

IAM roles with CloudWatch access

CloudWatch Log Groups

2️. user_data.sh runs on EC2 instances:

Installs Python & Flask

Installs CloudWatch Agent using .deb method

Deploys your local app.py from Terraform variable

Deploys requirements.txt

Creates and starts a systemd service for Flask

Pushes logs to CloudWatch Logs:

/home/ubuntu/app/app.log

/var/log/syslog

3. ALB performs health checks (/health)

If healthy → instance registered

If unhealthy → ASG replaces instance


🧪 Testing the API

Root endpoint:

curl http://ALB-DNS/

Health endpoint:

curl http://ALB-DNS/health


Or simply run:

./scripts/test.sh


1. VPC Creation

<img width="1146" height="357" alt="image" src="https://github.com/user-attachments/assets/560ac2ed-e961-4765-ba5d-d238af03d591" />


2. Subnets (Public + Private)

<img width="1149" height="308" alt="image" src="https://github.com/user-attachments/assets/af9b063a-f2fc-42a9-8237-79f82c489b75" />


2 Public Subnets

2 Private Subnets

3. Route Tables


Public Route Table → IGW

<img width="1147" height="404" alt="image" src="https://github.com/user-attachments/assets/d42313c5-dddf-47fe-b6f5-82955da24ab2" />


Private Route Table → NAT

<img width="1147" height="448" alt="image" src="https://github.com/user-attachments/assets/38f82fb0-4a94-4077-8053-4364c74927cf" />


4. ALB Configuration

Listener : HTTP 80

Target Group

/health endpoint

<img width="1174" height="468" alt="image" src="https://github.com/user-attachments/assets/70b0a356-73d9-4bdb-bbe9-f590cf44a846" />

<img width="1149" height="364" alt="image" src="https://github.com/user-attachments/assets/48d50af7-5d80-4037-a52b-58de8ffd74cc" />

<img width="1149" height="353" alt="image" src="https://github.com/user-attachments/assets/8e9ac436-c660-4c7b-b1f4-3b1ed6faf38b" />

<img width="1148" height="414" alt="image" src="https://github.com/user-attachments/assets/3faccbc6-d264-4c8a-8982-d208fd365d8a" />

<img width="1149" height="288" alt="image" src="https://github.com/user-attachments/assets/31641142-e7f0-4470-9b65-3af5de39fec2" />



5. Auto Scaling Group

Launch Template

Subnets

Instance count

<img width="1149" height="267" alt="image" src="https://github.com/user-attachments/assets/51b02936-423e-451c-b306-bcb9521fa103" />

<img width="1148" height="487" alt="image" src="https://github.com/user-attachments/assets/f89940b4-c2cb-4582-8a51-61b823792da5" />

6. EC2 Instance Details

Running from ASG

Private subnet

Systemd service → running

<img width="1149" height="484" alt="image" src="https://github.com/user-attachments/assets/db996216-ac4b-43ff-8651-bee05cd9abfd" />


7. Flask Application Output

<img width="1364" height="194" alt="image" src="https://github.com/user-attachments/assets/a17cbdca-df07-4a46-b925-153994920009" />

<img width="1365" height="180" alt="image" src="https://github.com/user-attachments/assets/f088731a-9307-4a3f-870a-4467db830ccc" />


8. CloudWatch Logs

<img width="1365" height="525" alt="image" src="https://github.com/user-attachments/assets/90238736-6a5b-44f8-a870-a88a4e04fe85" />


9. Terraform Apply Output


<img width="1016" height="270" alt="image" src="https://github.com/user-attachments/assets/1440c9cc-f91a-489c-a60e-7bf03b393eb9" />



Prerequisites Before Running deploy.sh / destroy.sh

✔ Install Terraform

Verify:

terraform -v

✔ Install AWS CLI

Verify:

aws --version

✔ Configure AWS Credentials

aws configure

✔ If using Windows → Install Git Bash

PowerShell cannot run .sh scripts.

Run using:

bash deploy.sh

Using deploy.sh

Git Bash / Linux / MacOS: 
./deploy.sh

PowerShell (Windows):
bash ./deploy.sh


This script:

Initializes Terraform

Applies configuration

Outputs ALB DNS

Shows testing commands

Using destroy.sh

Linux / Mac / Git Bash:
./destroy.sh


Windows PowerShell:
bash ./destroy.sh


The script asks for confirmation:

Type YES to confirm:

You must type:

YES

Testing with test.sh

Run:
./test.sh

It prints:
/
/health

Status codes

🛠️ Troubleshooting

❗ ALB DNS not found

terraform output


❗ Permission denied

chmod +x *.sh

❗ PowerShell cannot run .sh

bash deploy.sh




