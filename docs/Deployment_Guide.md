# Deployment & Execution Guide

**Author:** Akash Chaudhari  
**Cloud Provider:** Amazon Web Services (AWS)  
**Infrastructure as Code:** Terraform

---

# Table of Contents

1. Overview
2. Prerequisites
3. Repository Structure
4. S3 Backend Bootstrap Deployment
5. Configure Remote Backend
6. Terraform Infrastructure Deployment
7. Application Deployment
8. Validation Steps
9. Updating the Application
10. Terraform Outputs
11. Destroy Procedure
12. Conclusion

---

# 1. Overview

This guide provides step-by-step instructions for deploying the complete AWS infrastructure and hosting the Counter Application using Terraform.

The deployment is divided into two phases:

1. s3 Bootstrap Terraform Backend
2. Deploy Infrastructure and Application

This approach ensures that the Terraform state is securely stored in Amazon S3, while state locking is handled using Terraform's native S3 locking mechanism by enabling **use_lockfile = true**. This prevents multiple users from modifying the same state file simultaneously and helps avoid state corruption.

---

# 2. Prerequisites

Before deploying the project, ensure the following tools are installed.

| Software      | Version        |
|---------------|----------------|
| AWS CLI       | v2 or later    |
| Terraform     | v1.6+          |
| Git           | Latest         |
| AWS Account   | Active         |
| SSH Key Pair  | Created in AWS |

## Configure AWS CLI

```bash
aws configure
```

Provide:

- AWS Access Key ID
- AWS Secret Access Key
- Default Region
- Output Format

Verify access:

```bash
aws sts get-caller-identity
```

---

# 3. Repository Structure

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

# 4. Bootstrap Backend Deployment

Terraform uses a remote S3 backend to securely store the infrastructure state. The backend is configured to use **native S3 state locking** (`use_lockfile = true`), eliminating the need for a DynamoDB table.

The bootstrap configuration creates:

- Amazon S3 Bucket for storing the Terraform state file

Navigate to the bootstrap directory.

```bash
cd bootstrap
```

Initialize Terraform.

```bash
terraform init
```

Validate the configuration.

```bash
terraform validate
```

Review the execution plan.

```bash
terraform plan
```

Deploy the backend resources.

```bash
terraform apply
```

Expected resources:

- Amazon S3 Bucket for Terraform remote state

---

# 5. Configure Remote Backend

After the backend has been created, configure Terraform to use the remote S3 backend.

Example:

```hcl
terraform {
  backend "s3" {
    bucket       = "cloudops-s3-terraform-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

The `use_lockfile = true` setting enables **native S3 state locking**, preventing multiple users or processes from modifying the Terraform state simultaneously without requiring a DynamoDB table.

Initialize Terraform again to migrate the local state to the remote backend.


```bash
terraform init
```

Terraform migrates the local state to the remote backend.

---

# 6. Terraform Infrastructure Deployment

Navigate to the Terraform project.

```bash
cd terraform
```

Initialize Terraform.

```bash
terraform init
```

Validate configuration.

```bash
terraform validate
```

Format Terraform files.

```bash
terraform fmt
```

Review the execution plan.

```bash
terraform plan
```

Deploy the infrastructure.

```bash
terraform apply
```

Terraform provisions the following resources:

- VPC
- Public Subnets
- Private Application Subnets
- Private Database Subnets
- Internet Gateway
- NAT Gateway
- Security Groups
- IAM Roles
- Secrets Manager
- Amazon RDS
- Launch Template
- Auto Scaling Group
- Application Load Balancer
- S3 Artifact Bucket

---

# 7. Application Deployment

The application is packaged as a ZIP archive.

Create the application archive.

```bash
zip -r application.zip application/
```

Terraform uploads the archive to the Amazon S3 artifact bucket.

When an EC2 instance launches, the User Data script automatically:

- Installs Docker
- Downloads `application.zip` from Amazon S3
- Extracts the application
- Builds the Docker image
- Starts the Docker container

No manual deployment to EC2 is required.

---

# 8. Validation Steps

## Verify VPC

AWS Console

VPC → Verify:

- Public Subnets
- Private Subnets
- Route Tables
- NAT Gateway

---

## Verify EC2

AWS Console

EC2 → Instances

Verify:

- Running
- Healthy

---

## Verify Auto Scaling

AWS Console

EC2 → Auto Scaling Groups

Verify:

- Desired Capacity
- Healthy Instances

---

## Verify Load Balancer

AWS Console

EC2 → Load Balancers

Copy the ALB DNS Name and open it in a web browser.

The Counter Application should load successfully.

---

## Verify RDS

AWS Console

RDS → Database

Verify:

- Status = Available

---

## Verify Secrets Manager

AWS Console

Secrets Manager

Verify that the database credentials have been created successfully.

---

# 9. Updating the Application

To deploy a new version of the application:

### Step 1

Modify the application source files.

Examples:

- index.html
- style.css
- script.js

### Step 2

Run Terraform.

```bash
terraform apply
```

Terraform performs the following actions:

- Uploads the updated archive to Amazon S3.
- Updates the Launch Template.
- Creates a new Launch Template version.
- Auto Scaling Group detects the new version.
- Instance Refresh replaces existing EC2 instances.
- New EC2 instances download the latest application and start the updated Docker container.

---

# 10. Terraform Outputs

After deployment, Terraform displays important outputs.

Example:

- alb_dns_name
- autoscaling_group_name
- launch_template_id
- vpc_id
- public_subnet_ids
- private_app_subnet_ids
- private_db_subnet_ids
- rds_endpoint
- rds_secret_arn

Use the ALB DNS Name to access the application.

---

# 11. Destroy Procedure

Destroy the application infrastructure.

```bash
terraform destroy
```

After all infrastructure has been removed, navigate to the bootstrap directory.

```bash
cd bootstrap
```

Destroy the Terraform backend.

```bash
terraform destroy
```

> **Note:** If S3 bucket has enabled forece_delete = true, it will delete the s3 bucket else we have S3 bucket versioning is enabled, all object versions must be deleted before the bucket can be removed.

---

# 12. Conclusion

This deployment guide demonstrates a fully automated, reproducible AWS infrastructure built using Terraform.

By separating backend bootstrapping from infrastructure provisioning and leveraging managed AWS services such as Amazon RDS, Auto Scaling, Application Load Balancer, and Amazon S3, the solution provides a secure, scalable, and highly available platform for hosting the Counter Application.

The modular Terraform design also makes the infrastructure easy to maintain and extend with future enhancements such as HTTPS, CI/CD pipelines, container orchestration, centralized logging, and advanced monitoring.



🙋‍♂️ Maintainer GitHub: @akashchaudhari8865
