# Deploy Stage Pipeline

This folder contains a **Deploy Stage Jenkins Pipeline** example that demonstrates how to deploy a Java web application to **Apache Tomcat** server.

---

## 📌 Overview

The `Deploy_stage_pipeline` automates the deployment of a Java web application (WAR file) to a Tomcat server. It ensures smooth delivery of your application after the build and test stages.

---

## 🛠️ Pipeline Stages

| Stage    | Description                                                            |
| -------- | ---------------------------------------------------------------------- |
| Checkout | Pulls code from the Git repository.                                    |
| Build    | Compiles and packages the application (e.g., Maven `clean install`).   |
| Test     | Runs automated tests (optional if already done in Test Stage).         |
| Deploy   | Deploys the WAR file to Tomcat server using `deploy` plugin or script. |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* Maven installed on Jenkins agent
* Tomcat server installed and accessible
* Jenkins Tomcat plugin (optional) or SSH access to the server
* Access to the repository containing the Java project

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from `Deploy_stage_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Configure Tomcat credentials in Jenkins (if using plugin).
6. Run the pipeline to deploy the application.

### Example Jenkinsfile Snippet

```groovy
stage('Deploy to Tomcat') {
    steps {
        deploy adapters: [tomcat9(credentialsId: 'tomcat-credentials', path: '', url: 'http://tomcat-server:8080')],
        contextPath: '/myapp',
        war: '**/target/myapp.war'
    }
}
```

---

## ⚙️ Customization

* Update Git repository URL and project WAR file path.
* Modify the Tomcat server URL and credentials.
* Add pre-deployment steps like backup or health checks.
* Integrate with build/test stages as needed.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, improve deployment steps, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
