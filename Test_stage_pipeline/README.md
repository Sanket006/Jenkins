# Test Stage Pipeline

This folder contains a **Test Stage Jenkins Pipeline** example that demonstrates how to run automated tests and integrate **SonarQube** for code quality analysis, including enforcing a **quality gate**.

---

## 📌 Overview

The `Test_stage_pipeline` automates testing and code quality checks. It uses **SonarQube** to analyze the code and fail the pipeline if the project does not meet the defined quality gate standards.

---

## 🛠️ Pipeline Stages

| Stage              | Description                                                              |
| ------------------ | ------------------------------------------------------------------------ |
| Checkout           | Pulls code from the Git repository.                                      |
| Build              | Compiles the application (can use Maven or Gradle).                      |
| Test               | Runs automated tests.                                                    |
| SonarQube Analysis | Sends code metrics to SonarQube for analysis.                            |
| Quality Gate       | Checks SonarQube quality gate; fails the build if standards are not met. |
| Deploy (Optional)  | Deploys the application if tests and quality gate pass.                  |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* SonarQube server installed or accessible
* SonarQube plugin installed in Jenkins
* Maven or Gradle installed on Jenkins agent
* Access to the repository containing the project

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from the `Test_stage_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Configure SonarQube server in Jenkins credentials.
6. Run the pipeline.

### Example Jenkinsfile Snippet

```groovy
stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('MySonarQubeServer') {
            sh 'mvn sonar:sonar'
        }
    }
}

stage('Quality Gate') {
    steps {
        timeout(time: 10, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
        }
    }
}
```

---

## ⚙️ Customization

* Update the Git repository URL in the `Jenkinsfile`.
* Adjust the build tool and commands as needed.
* Configure the SonarQube server and quality gate settings.
* Add additional stages like packaging or deployment.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, improve the pipeline, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
