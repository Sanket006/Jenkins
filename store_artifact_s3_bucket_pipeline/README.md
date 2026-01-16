# Store Artifact to S3 Bucket Pipeline

This folder contains a **Jenkins Pipeline** that demonstrates how to build an application and store the generated artifacts in an **AWS S3 bucket**.

---

## 📌 Overview

The `store_artifact_s3_bucket_pipeline` automates the process of compiling code, packaging it, and uploading the resulting artifacts to an Amazon S3 bucket for storage or later deployment.

---

## 🛠️ Pipeline Stages

| Stage           | Description                                                         |
| --------------- | ------------------------------------------------------------------- |
| Checkout        | Pulls code from the Git repository.                                 |
| Build           | Compiles and packages the application (e.g., using Maven).          |
| Test (Optional) | Runs automated tests if required.                                   |
| Upload to S3    | Uploads the built artifacts to a specified S3 bucket using AWS CLI. |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* AWS CLI installed on Jenkins agent
* AWS credentials configured in Jenkins (access key ID and secret key)
* S3 bucket created and accessible
* Maven or other build tools installed (if required)

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from `store_artifact_s3_bucket_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Configure AWS credentials in Jenkins.
6. Run the pipeline.

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
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Upload to S3') {
            steps {
                sh 'aws s3 cp target/myapp.war s3://my-s3-bucket/'
            }
        }
    }
}
```

---

## ⚙️ Customization

* Replace `my-s3-bucket` with your S3 bucket name.
* Update the build command according to your project requirements.
* Add additional stages like testing, code analysis, or deployment.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, improve the pipeline, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
