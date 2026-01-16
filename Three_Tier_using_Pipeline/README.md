# Three Tier Application Pipeline

This folder contains a **Three Tier Application Jenkins Pipeline** example that demonstrates deploying a multi-tier application using a Jenkins pipeline (`simple_deploy_jenkinsfile.jdp`).

---

## 📌 Overview

The `Three_Tier_using_Pipeline` pipeline automates the deployment of a multi-tier application (typically Web, Application, and Database tiers) using Jenkins. It ensures that all tiers are deployed in the correct order, and includes build, test, and deployment stages.

---

## 🛠️ Pipeline Stages

| Stage              | Description                                                                      |
| ------------------ | -------------------------------------------------------------------------------- |
| Checkout           | Pulls code for all tiers from Git repositories.                                  |
| Build              | Builds each tier as required (e.g., Java apps using Maven, front-end using npm). |
| Test               | Runs automated tests for each tier.                                              |
| Deploy Database    | Deploys the database tier (e.g., MySQL, PostgreSQL).                             |
| Deploy Application | Deploys the application tier connecting to the database.                         |
| Deploy Web         | Deploys the front-end/web tier.                                                  |
| Verification       | Optional tests to verify successful deployment.                                  |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* Build tools installed (e.g., Maven, npm)
* Database server accessible (if deploying database tier)
* Deployment targets configured (e.g., Tomcat, Docker, Kubernetes)

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `simple_deploy_jenkinsfile.jdp` from `Three_Tier_using_Pipeline` folder.
4. Paste it into the pipeline configuration.
5. Update environment variables, repository URLs, and deployment targets in the Jenkinsfile.
6. Run the pipeline.

### Example Jenkinsfile Snippet

```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanket006/Jenkins.git', branch: 'main'
            }
        }
        stage('Build Tiers') {
            steps {
                sh './build.sh'
            }
        }
        stage('Deploy Database') {
            steps {
                sh './deploy_db.sh'
            }
        }
        stage('Deploy Application') {
            steps {
                sh './deploy_app.sh'
            }
        }
        stage('Deploy Web') {
            steps {
                sh './deploy_web.sh'
            }
        }
    }
}
```

---

## ⚙️ Customization

* Update repository URLs for each tier.
* Modify build commands based on your project requirements.
* Adjust deployment scripts to match your servers and environment.
* Add pre-deployment or post-deployment verification steps.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, improve the pipeline, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.



