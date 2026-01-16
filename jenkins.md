# Jenkins Pipelines

Welcome to the **Jenkins Pipelines** repository! This repository contains a collection of Jenkins pipelines for CI/CD tasks such as building, testing, deploying, and managing infrastructure.

---

## 🚀 Repository Overview

| Pipeline                          | Description                                 |
| --------------------------------- | ------------------------------------------- |
| Basic_pipeline                    | Demonstrates basic Jenkins stages.          |
| Build_stage_pipeline              | Focused on building applications.           |
| Deploy_stage_pipeline             | Includes deployment stages.                 |
| Pull_stage_pipeline               | Automates code pull and integration.        |
| SSH_agent_pipeline                | Uses SSH agent for secure deployments.      |
| Terraform_EKS_pipeline            | Provision EKS clusters using Terraform.     |
| Test_stage_pipeline               | Pipeline with testing stages.               |
| Three_Tier_using_Pipeline         | Multi-tier application deployment pipeline. |
| store_artifact_s3_bucket_pipeline | Stores build artifacts in an S3 bucket.     |

---

## 🛠️ Getting Started

### Prerequisites

* Jenkins installed and running
* Required Jenkins plugins: Pipeline, Git, SSH Agent, AWS CLI (if using S3/Terraform pipelines)
* Access to the necessary Git repositories and AWS credentials

### Steps to Run a Pipeline

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline.
3. Copy the desired **Jenkinsfile** from the repository.
4. Paste it into your Jenkins pipeline configuration.
5. Customize the script for your environment (credentials, servers, etc.).
6. Run the pipeline and monitor the stages in Jenkins.

---

## 🤝 Contributing

We welcome contributions! Feel free to fork the repository and add new pipelines or improvements. Submit pull requests for review.

---

## 📄 License

This project is open source under the **MIT License**.
