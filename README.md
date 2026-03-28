# 🔧 jenkins-cicd-pipelines

<div align="center">

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Groovy](https://img.shields.io/badge/Groovy-4298B8?style=for-the-badge&logo=apachegroovy&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![AWS EKS](https://img.shields.io/badge/AWS_EKS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white)

*9 production-ready Jenkins declarative pipelines — from basic CI stages to SonarQube code quality gates, Tomcat WAR deployment, S3 artifact archiving, and full AWS EKS cluster provisioning via Terraform*

</div>

---

## 📌 Overview

A complete collection of **Jenkins Declarative Pipelines** covering every major CI/CD pattern used in real DevOps workflows. Each folder is a standalone, plug-and-play pipeline — progress from a basic hello-world skeleton all the way up to provisioning a production AWS EKS cluster entirely inside a Jenkins job.

---

## 📁 Pipeline Collection

| # | Folder | What It Does |
|---|---|---|
| 1 | `Basic_pipeline` | Foundation — 4-stage skeleton (Pull → Build → Test → Deploy) with echo steps |
| 2 | `Pull_stage_pipeline` | Pulls source from GitHub (`EasyCRUD`, `main` branch) into Jenkins workspace |
| 3 | `Build_stage_pipeline` | Pulls `EasyCRUD` + runs `mvn clean package -DskipTests` on `backend/` |
| 4 | `Test_stage_pipeline` | Maven build → SonarQube analysis → Quality Gate (30s timeout, aborts on fail) |
| 5 | `Deploy_stage_pipeline` | Maven build → deploys WAR to Tomcat on EC2 via `curl` + Tomcat Manager API |
| 6 | `SSH_agent_pipeline` | Runs pipeline on a dedicated Jenkins agent with label `ssh-agent` |
| 7 | `store_artifact_s3_bucket_pipeline` | Maven build → SonarQube → Quality Gate → uploads JAR to AWS S3 |
| 8 | `Three_Tier_using_Pipeline` | Builds & pushes Docker images → configures EKS → `kubectl apply` |
| 9 | `Terraform_EKS_pipeline` | **Provisions a full AWS EKS cluster via Terraform inside Jenkins** |

---

## 🔄 Learning Progression

```
Basic_pipeline                  ← Start here — understand declarative syntax
        │
        ▼
Pull_stage_pipeline             ← Add real SCM checkout from GitHub
        │
        ▼
Build_stage_pipeline            ← Add Maven build (mvn clean package)
        │
        ▼
Test_stage_pipeline             ← Add SonarQube analysis + Quality Gate
        │
        ▼
Deploy_stage_pipeline           ← Deploy WAR to Tomcat via Tomcat Manager API
        │
        ▼
SSH_agent_pipeline              ← Route pipeline to a dedicated SSH agent node
        │
        ▼
store_artifact_s3_bucket_pipeline ← Build → SonarQube → upload JAR to S3
        │
        ▼
Three_Tier_using_Pipeline       ← Build Docker images → push → deploy to EKS
        │
        ▼
Terraform_EKS_pipeline          ← Provision the EKS cluster itself via Terraform
```

---

## 📂 Pipeline Details

---

### 1️⃣ Basic Pipeline (`Basic_pipeline/`)

The simplest starting point — a 4-stage declarative skeleton with `echo` steps. Use this to understand Jenkinsfile structure before adding real logic.

```groovy
pipeline {
    agent any
    stages {
        stage('Pull')   { steps { echo 'Pulling code' } }
        stage('Build')  { steps { echo 'Building successfully' } }
        stage('Test')   { steps { echo 'Testing successfully' } }
        stage('Deploy') { steps { echo 'Deploying successfully' } }
    }
}
```

**File:** `Basic_pipeline/basic_Jenkinfile.jdp`

---

### 2️⃣ Pull Stage Pipeline (`Pull_stage_pipeline/`)

Adds a real SCM checkout step — pulls the `EasyCRUD` repo from GitHub on `main` branch.

```groovy
stage('Pull') {
    steps {
        git branch: 'main',
            url: 'https://github.com/Sanket006/crud-app-aws-ec2-rds.git'
    }
}
```

**File:** `Pull_stage_pipeline/pull_jenkinsfile.jdp`

---

### 3️⃣ Build Stage Pipeline (`Build_stage_pipeline/`)

Pulls `EasyCRUD` source and runs a Maven build on the `backend/` directory, skipping tests for a fast build cycle.

```groovy
stage('Pull') {
    steps {
        git branch: 'main', url: 'https://github.com/Sanket006/crud-app-aws-ec2-rds.git'
    }
}
stage('Build') {
    steps {
        sh '''cd backend
              mvn clean package -DskipTests'''
    }
}
```

**File:** `Build_stage_pipeline/build_jenkinsfile.jdp`
**Requires:** Maven installed on Jenkins agent, Java SDK

---

### 4️⃣ Test Stage Pipeline (`Test_stage_pipeline/`)

The quality-gate pipeline — builds the Spring Boot backend with Maven, runs SonarQube static analysis, and enforces a quality gate with a **30-second timeout** that aborts the pipeline on failure.

```groovy
stage('Build') {
    steps {
        sh '''cd backend
              mvn clean package -DskipTests'''
    }
}
stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'sonar-cred') {
            sh '''cd backend
                  mvn sonar:sonar \
                  -Dsonar.projectKey=studentapp \
                  -Dsonar.projectName='studentapp' '''
        }
    }
}
stage('Quality Gate') {
    steps {
        timeout(time: 30, unit: 'SECONDS') {
            waitForQualityGate abortPipeline: true, credentialsId: 'sonar-cred'
        }
    }
}
```

**File:** `Test_stage_pipeline/test_jenkinsfile.jdp`
**Requires:** SonarQube server configured in Jenkins → `sonar-cred` credential ID

---

### 5️⃣ Deploy Stage Pipeline (`Deploy_stage_pipeline/`)

Pulls the `student-ui` project, builds a WAR with Maven, and deploys it to an Apache Tomcat server on EC2 using the **Tomcat Manager REST API** via `curl`. Uses Jenkins `withCredentials` to inject Tomcat credentials securely.

```groovy
environment {
    TOMCAT_URL = "http://65.2.121.231:8080"
    APP_NAME   = "studentapp"
}

stage('Pull') {
    steps {
        git branch: 'master', url: 'https://github.com/Sanket006/student-ui.git'
    }
}
stage('Build WAR') {
    steps { sh 'mvn clean package' }
}
stage('Deploy to EC2 Tomcat') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'tomcat-cred',
            usernameVariable: 'TOMCAT_USER',
            passwordVariable: 'TOMCAT_PASS'
        )]) {
            sh '''
            curl -u $TOMCAT_USER:$TOMCAT_PASS \
                 -T target/*.war \
                 "$TOMCAT_URL/manager/text/deploy?path=/$APP_NAME&update=true"
            '''
        }
    }
}
```

**File:** `Deploy_stage_pipeline/deploy_jenkinsfile.jdp`
**Requires:** `tomcat-cred` credential in Jenkins, Tomcat Manager enabled on EC2

---

### 6️⃣ SSH Agent Pipeline (`SSH_agent_pipeline/`)

Routes the entire pipeline to run on a Jenkins agent node with label `ssh-agent` — useful when specific build tools (Docker, kubectl, etc.) are only installed on designated agents.

```groovy
pipeline {
    agent { label 'ssh-agent' }
    stages {
        stage('Pull') {
            steps {
                git 'https://github.com/Sanket006/crud-app-aws-ec2-rds.git'
            }
        }
        // ... build, test, deploy stages
    }
}
```

**File:** `SSH_agent_pipeline/agent_jenkinfile.jdp`
**Requires:** Jenkins agent registered with label `ssh-agent`

---

### 7️⃣ Store Artifact to S3 Pipeline (`store_artifact_s3_bucket_pipeline/`)

Full quality pipeline — Maven build → SonarQube analysis with 30s quality gate → uploads compiled JAR to `s3://my-artifact-bucket-jar-file/artifacts/` using AWS credentials stored in Jenkins.

```groovy
stage('Build') {
    steps {
        sh '''cd backend && mvn clean package -DskipTests'''
    }
}
stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'sonar-cred') {
            sh '''cd backend
                  mvn sonar:sonar \
                  -Dsonar.projectKey=studentapp \
                  -Dsonar.projectName='studentapp' '''
        }
    }
}
stage('Quality Gate') {
    steps {
        timeout(time: 30, unit: 'SECONDS') {
            waitForQualityGate abortPipeline: true, credentialsId: 'sonar-cred'
        }
    }
}
stage('Upload JAR to S3') {
    steps {
        withCredentials([aws(
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
            credentialsId: 'aws-s3-cred'
        )]) {
            sh 'aws s3 cp backend/target/*.jar s3://my-artifact-bucket-jar-file/artifacts/'
        }
    }
}
```

**File:** `store_artifact_s3_bucket_pipeline/store_artifact_s3bucket_jenkinsfile.jdp`
**Requires:** `sonar-cred` + `aws-s3-cred` in Jenkins, S3 bucket created

---

### 8️⃣ Three-Tier Application Pipeline (`Three_Tier_using_Pipeline/`)

End-to-end Docker image build and Kubernetes deployment pipeline — builds backend and frontend Docker images, pushes to DockerHub, configures kubectl for `demo-eks-cluster` in `ap-south-1`, and applies all manifests from `simple-deploy/`.

```groovy
stage('Build Backend Image') {
    steps {
        sh '''cd backend
              docker build -t sanket006/easy-backend:latest .'''
    }
}
stage('Push Backend Image') {
    steps {
        sh '''docker push sanket006/easy-backend:latest
              docker rmi -f sanket006/easy-backend:latest'''
    }
}
// ... same for frontend
stage('Configure Kubeconfig') {
    steps {
        sh '''aws eks update-kubeconfig --region ap-south-1 --name demo-eks-cluster
              kubectl get nodes'''
    }
}
stage('Deploy to Kubernetes') {
    steps {
        sh 'kubectl apply -f simple-deploy/'
    }
}
```

**File:** `Three_Tier_using_Pipeline/simple_deploy_jenkinsfile.jdp`
**Requires:** Docker + AWS CLI + kubectl on agent, DockerHub credentials, EKS cluster running

---

### 9️⃣ Terraform EKS Pipeline (`Terraform_EKS_pipeline/`) ⭐ Most Advanced

**Provisions a complete AWS EKS cluster entirely from inside a Jenkins job** using Terraform. No manual AWS console work — Jenkins runs `terraform init → plan → apply` and the cluster is ready.

```groovy
environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-s3-cred')
    AWS_SECRET_ACCESS_KEY = credentials('aws-s3-cred')
    AWS_DEFAULT_REGION    = 'ap-south-1'
}

stage('Terraform Init')  { steps { sh 'cd Terraform_EKS_pipeline && terraform init' } }
stage('Terraform Plan')  { steps { sh 'cd Terraform_EKS_pipeline && terraform plan' } }
stage('Terraform Apply') { steps { sh 'cd Terraform_EKS_pipeline && terraform apply -auto-approve' } }
```

**What Terraform provisions:**

| Resource | Detail |
|---|---|
| `aws_iam_role` — cluster | `eks-cluster-role` with `AmazonEKSClusterPolicy` |
| `aws_iam_role` — nodes | `eks-node-role` with `AmazonEKSWorkerNodePolicy` + `AmazonEKS_CNI_Policy` + `AmazonEC2ContainerRegistryReadOnly` |
| `aws_eks_cluster` | `demo-eks-cluster` — uses default VPC, `endpoint_public_access = true` |
| `aws_eks_node_group` | `demo-node-group` — 2 × `c7i-flex.large` nodes (min 1, max 3) |

**Files:** `Terraform_EKS_pipeline/terraform_eks_jenkinsfile.jdp`, `main.tf`, `variable.tf`, `output.tf`
**Requires:** `aws-s3-cred` AWS credential in Jenkins, Terraform CLI on agent

---

## 🚀 Getting Started

### Prerequisites

Install the following Jenkins plugins:

| Plugin | Required By |
|---|---|
| `Pipeline` | All pipelines |
| `Git` | All pipelines |
| `SonarQube Scanner` | Pipelines 4, 7 |
| `SSH Agent` | Pipeline 6 |
| `AWS Credentials` | Pipelines 7, 8, 9 |
| `Docker Pipeline` | Pipeline 8 |

### Set Up Jenkins Credentials

Go to **Jenkins → Manage Jenkins → Credentials → Add**:

| Credential ID | Type | Used By |
|---|---|---|
| `sonar-cred` | Secret text | Test stage, S3 artifact pipelines |
| `tomcat-cred` | Username + password | Deploy stage pipeline |
| `aws-s3-cred` | AWS credentials | S3 artifact + Terraform EKS pipelines |

### Run Any Pipeline

```bash
# 1. Clone the repo
git clone https://github.com/Sanket006/jenkins-cicd-pipelines.git

# 2. In Jenkins: New Item → Pipeline
#    Pipeline Definition: Pipeline script from SCM
#    SCM: Git → repo URL → branch: main
#    Script Path: <FolderName>/<filename>.jdp

# 3. Click Build Now (or configure a webhook to auto-trigger on push)
```

---

## 🔗 Related Projects

| Repo | Description |
|---|---|
| [terraform-aws-iac](https://github.com/Sanket006/terraform-aws-iac) | Standalone Terraform modules — VPC, EC2, IAM, S3, RDS |
| [student-app-kubernetes](https://github.com/Sanket006/student-app-kubernetes) | App deployed by the Three-Tier pipeline |
| [nodejs-app-jenkins-pipeline](https://github.com/Sanket006/nodejs-app-jenkins-pipeline) | End-to-end pipeline: Docker build → push → EKS deploy |
| [flight-reservation-aws-infra](https://github.com/Sanket006/flight-reservation-aws-infra) | Terraform infra provisioned by the EKS pipeline pattern |

---

## 👨‍💻 Author

**Sanket Ajay Chopade** — DevOps Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sanketchopade07)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/Sanket006)
