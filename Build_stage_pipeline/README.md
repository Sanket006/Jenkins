# Build Stage Pipeline

This folder contains a **Build Stage Jenkins Pipeline** example that demonstrates how to build a Java project using **Maven** with the `-DskipTests` flag to skip running tests during the build stage.

---

## 📌 Overview

The `Build_stage_pipeline` is designed to automate the build process for Java projects. It focuses on compiling the code and packaging the application without executing tests.

---

## 🛠️ Pipeline Stages

| Stage             | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| Checkout          | Pulls code from the Git repository.                                   |
| Build             | Compiles and packages the application using Maven with `-DskipTests`. |
| Archive           | Stores the built artifacts for later use.                             |
| Deploy (Optional) | Deploys the application if needed.                                    |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* Maven installed on the Jenkins agent
* Java SDK installed
* Access to the repository containing the Java project

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from `Build_stage_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Run the pipeline.

### Example Build Command in Jenkinsfile

```groovy
stage('Build') {
    steps {
        sh 'mvn clean install -DskipTests'
    }
}
```

---

## ⚙️ Customization

* Update the Git repository URL in the `Jenkinsfile`.
* Modify Maven commands as needed (e.g., include tests or use profiles).
* Add additional stages like code analysis, packaging, or deployment.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, make improvements, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
