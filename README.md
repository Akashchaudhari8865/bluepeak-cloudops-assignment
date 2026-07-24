# BluePeak CloudOps Assignment

AWS Cloud Infrastructure using Terraform for deploying a highly available, scalable, and secure three-tier web application.

---

# Project Overview

This project demonstrates the migration of a simple web application from an on-premises environment to AWS using Infrastructure as Code (Terraform).

The solution provisions a complete AWS infrastructure consisting of networking, compute, load balancing, database, security, and storage components. The sample Counter Application (Increment/Decrement) is containerized using Docker and automatically deployed on Amazon EC2 instances managed by an Auto Scaling Group.

The infrastructure follows AWS Well-Architected best practices with a focus on security, scalability, high availability, and automation.

---

# Architecture

> **Architecture Diagram**

<img width="1892" height="1279" alt="CloudOpsAssignment-Architecture drawio" src="https://github.com/user-attachments/assets/935adef7-1441-4f8d-a628-b36c5ce20ea3" />


A detailed architecture diagram is also available in:

- `docs/Architecture_Diagram.drawio`
- `docs/Architecture_Diagram.svg`

---

# Features

- Infrastructure provisioned entirely using Terraform
- Modular Terraform project structure
- Remote Terraform backend using Amazon S3
- Native Terraform state locking (`use_lockfile = true`)
- Highly available VPC across two Availability Zones
- Public and private subnet architecture
- Internet-facing Application Load Balancer
- EC2 instances deployed in private subnets
- Auto Scaling Group with Launch Templates
- Automatic rolling instance refresh during application updates
- Amazon RDS MySQL database deployed in private subnets
- Database credentials stored securely in AWS Secrets Manager
- Docker-based application deployment
- Application artifacts stored in Amazon S3
- IAM roles with least-privilege permissions
- Security Groups following least access principle

---

# Technologies Used

### Cloud

- Amazon Web Services (AWS)

### Infrastructure as Code

- Terraform

### Compute

- Amazon EC2
- Auto Scaling Group
- Launch Template

### Networking

- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

### Load Balancing

- Application Load Balancer (ALB)

### Database

- Amazon RDS (MySQL)

### Storage

- Amazon S3

### Security

- IAM
- Security Groups
- AWS Secrets Manager

### Containerization

- Docker

### Application

- HTML
- CSS
- JavaScript

---

# Project Structure

```text
bluepeak-cloudops-assignment/

├── app/                # Counter application source code
│
├── s3-backend-bootstrap/                  # Terraform backend (S3)
│
├── terraform/
│   ├── modules/
│   │   ├── networking/
│   │   ├── security/
│   │   ├── alb/
│   │   ├── ec2/
│   │   ├── autoscaling/
│   │   └── rds/
│   │
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── outputs.tf
│   └── main.tf
│
├── docs/
│   ├── Technical_Design_Document.pdf
│   ├── Deployment_Guide.md
│   ├── CloudOpsAssignment-Architecture.drawio
│   ├── CloudOpsAssignment-Architecture.drawio.svg
│   └── CloudOpsAssignment-Architecture.drawio.png
│
└── README.md
```

---

# Quick Deployment

## Step 1 - Clone Repository

```bash
git clone <repository-url>

cd bluepeak-cloudops-assignment
```

---

## Step 2 - Deploy Terraform Backend

```bash
cd s3-backend-bootstrap/

terraform init

terraform apply
```

---

## Step 3 - Deploy Infrastructure

```bash
cd ..

cd terraform/

terraform init

terraform apply
```

---

## Step 4 - Access Application

After deployment completes, Terraform displays the Application Load Balancer DNS name.

Open the ALB DNS URL in your browser to access the Counter Application.

use like : http://cloudops-dev-alb-2088906736.us-east-1.elb.amazonaws.com/

---

# Terraform Outputs

After a successful deployment, Terraform provides the following outputs:

| Output                    | Description                   |
|---------------------------|-------------------------------|
| `alb_dns_name`            | Application Load Balancer DNS |
| `autoscaling_group_name`  | Auto Scaling Group Name       |
| `launch_template_id`      | Launch Template ID            |
| `private_app_subnet_ids`  | Private Application Subnets   |
| `private_db_subnet_ids`   | Private Database Subnets      |
| `public_subnet_ids`       | Public Subnets                |
| `vpc_id`                  | VPC ID                        |
| `rds_endpoint`            | Amazon RDS Endpoint           |
| `rds_secret_arn`          | AWS Secrets Manager ARN       |
_____________________________________________________________

---

# Screenshots

## Infrastructure

### 1. VPC

<img width="1915" height="849" alt="image" src="https://github.com/user-attachments/assets/c337ccd7-f0fc-4070-bb54-6fd293039e82" />


**Project Explanation**

A dedicated VPC is created to isolate all infrastructure resources. This VPC acts as the network boundary for the complete application and contains separate public, application, and database subnets across two Availability Zones.

---

### 2. Public & Private Subnets
Public Subnets :
<img width="1920" height="857" alt="image" src="https://github.com/user-attachments/assets/a038d4c2-b5c5-4164-aebc-5306350b63c9" />

Private Subnets :
<img width="1915" height="852" alt="image" src="https://github.com/user-attachments/assets/f48c5762-75fe-4376-a113-73c7b7dfa0bd" />

**Project Explanation**

The infrastructure is divided into three subnet layers:

- Public Subnets host the Application Load Balancer and NAT Gateway.
- Private Application Subnets host the EC2 instances created by the Auto Scaling Group.
- Private Database Subnets host the Amazon RDS MySQL database.

The EC2 instances never receive public IP addresses. Internet users can only access the application through the Load Balancer.

---

### 3. Route Tables

<img width="1910" height="858" alt="image" src="https://github.com/user-attachments/assets/35619112-7e2c-4962-a52f-ece71b080698" />


**Project Explanation**

Separate route tables are configured for each subnet type.

- Public subnet traffic is routed through the Internet Gateway.
- Private application subnets use the NAT Gateway for outbound internet access.
- Database subnets remain isolated and only communicate with the application layer.

This routing ensures secure communication between each tier.

---

### 4. NAT Gateway

<img width="1920" height="848" alt="image" src="https://github.com/user-attachments/assets/58770221-f1e6-45de-ad36-214fd239ec86" />

**Project Explanation**

The EC2 instances are deployed inside private subnets and therefore cannot access the internet directly.

The NAT Gateway allows these instances to:

- install Docker packages
- download the application.zip artifact from the S3 bucket
- receive operating system updates

while remaining inaccessible from the public internet.

---

# Compute

### 5. EC2 Instances

<img width="1916" height="853" alt="image" src="https://github.com/user-attachments/assets/822f1889-20ab-482b-8036-4b5a335eb54c" />

**Project Explanation**

The Auto Scaling Group launches EC2 instances using the Launch Template.

During instance startup, the User Data script automatically:

1. Installs Docker and AWS CLI
2. Downloads **application.zip** from the S3 artifact bucket
3. Extracts the application files
4. Builds the Docker image
5. Starts the Counter Application container

The application becomes available through the Application Load Balancer without any manual deployment.

---

### 6. Auto Scaling Group

<img width="1920" height="848" alt="image" src="https://github.com/user-attachments/assets/f2a88a1b-1940-48be-8bbc-e9d5c09aa777" />


**Project Explanation**

The Auto Scaling Group maintains the desired number of EC2 instances across two Availability Zones.

It is connected directly to the Target Group, allowing only healthy instances to receive traffic.

Whenever the Launch Template version changes after a new application deployment, the Auto Scaling Group performs an Instance Refresh to gradually replace old EC2 instances with newly launched instances.

---

### 7. Launch Template

<img width="1913" height="848" alt="image" src="https://github.com/user-attachments/assets/6950f8cb-5891-4a8c-b4de-7ddd712de971" />

**Project Explanation**

The Launch Template contains the complete EC2 configuration used by the Auto Scaling Group, including:

- Amazon Linux 2023 AMI
- Instance Type
- IAM Instance Profile
- Security Group
- Root Volume
- User Data deployment script

Terraform automatically creates a new Launch Template version whenever the application artifact changes, ensuring newly launched EC2 instances always deploy the latest application version.

---

# Load Balancer

### 8. Application Load Balancer

<img width="1914" height="851" alt="image" src="https://github.com/user-attachments/assets/bad4f557-1f76-4562-8cf8-d1d4f2e4c713" />

**Project Explanation**

The Application Load Balancer is deployed in the public subnets and serves as the only internet-facing component.

All HTTP requests are received by the ALB and forwarded to the Target Group, which distributes traffic across healthy EC2 instances running in private subnets.

This architecture prevents direct public access to EC2 instances.

---

### 9. Target Group

<img width="1912" height="850" alt="image" src="https://github.com/user-attachments/assets/86489a34-2f46-4d90-8848-aaed0e6c4a6f" />

**Project Explanation**

The Target Group registers EC2 instances created by the Auto Scaling Group.

Health checks are performed on the application before traffic is routed to an instance.

If an instance becomes unhealthy, it is automatically removed from the Target Group until it passes the health check again.

---

# Database

### 10. Amazon RDS

<img width="1916" height="850" alt="image" src="https://github.com/user-attachments/assets/25932e5a-a926-43bd-8197-61b1be71c36a" />

**Project Explanation**

Amazon RDS MySQL is deployed inside private database subnets.

Only EC2 instances belonging to the application security group can connect to the database.

The database is completely isolated from the internet, improving security while providing a managed database service.

---

### 11. AWS Secrets Manager

<img width="1782" height="801" alt="image" src="https://github.com/user-attachments/assets/782260c5-6c9a-462a-9845-083523e8f80c" />

**Project Explanation**

Database credentials are securely stored in AWS Secrets Manager.

Terraform provisions the RDS instance and retrieves the generated Secret ARN as an output.

This approach avoids storing sensitive credentials inside Terraform code or application configuration.

---

# Application

### 12. Counter Application

<img width="1920" height="961" alt="image" src="https://github.com/user-attachments/assets/cdee5afc-52b7-4121-a24d-3f66f3a31ab1" />


**Project Explanation**

The Counter Application is packaged into **application.zip** and uploaded to the S3 artifact bucket through Terraform.

When a new version of the application is uploaded:

- Terraform updates the S3 object.
- A new Launch Template version is created.
- The Auto Scaling Group performs an Instance Refresh.
- New EC2 instances download the updated application from S3 during boot.
- The Application Load Balancer automatically routes traffic to the refreshed instances.

This provides an automated deployment workflow without manually logging into EC2 instances.

---

# Documentation

Additional documentation is available in the **docs** folder.

- Technical Design Document
- Deployment Guide
- Architecture Diagram
- Draw.io Source File

---

# Author

**Akash Chaudhari**
github@akashchaudhari8865
