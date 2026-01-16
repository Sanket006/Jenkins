# Terraform EKS Pipeline

This folder contains a **Jenkins Pipeline** that demonstrates how to provision an **AWS EKS (Elastic Kubernetes Service) cluster** using **Terraform**.

---

## 📌 Overview

The `Terraform_EKS_pipeline` automates the deployment of an EKS cluster on AWS using Terraform scripts. It handles infrastructure provisioning, configuration, and can be integrated with subsequent CI/CD stages.

---

## 🛠️ Pipeline Stages

| Stage           | Description                                                                        |
| --------------- | ---------------------------------------------------------------------------------- |
| Checkout        | Pulls Terraform code from the Git repository.                                      |
| Terraform Init  | Initializes Terraform configuration.                                               |
| Terraform Plan  | Creates an execution plan and shows what changes will be applied.                  |
| Terraform Apply | Applies the Terraform plan to provision resources.                                 |
| Post-Apply      | Optional stages like configuring kubectl, deploying applications, or verification. |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* Terraform installed on Jenkins agent
* AWS CLI installed and configured with access keys
* AWS IAM role with permissions to create EKS, VPC, and related resources
* Kubernetes CLI (`kubectl`) installed if post-deployment steps are needed

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from `Terraform_EKS_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Update AWS credentials and Terraform variable files.
6. Run the pipeline to provision the EKS cluster.

### Example Jenkinsfile Snippet

```groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanket006/Jenkins.git', branch: 'main'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init terraform/EKS'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file=terraform/EKS/vars.tfvars'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve -var-file=terraform/EKS/vars.tfvars'
            }
        }
    }
}
```

---

## ⚙️ Customization

* Update Terraform scripts and variable files according to your AWS environment.
* Configure AWS credentials in Jenkins.
* Add post-provisioning steps such as deploying applications to EKS.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, improve Terraform scripts or pipeline stages, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
