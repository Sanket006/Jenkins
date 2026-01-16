# SSH Agent Pipeline

This folder contains a **Jenkins Pipeline using SSH Agent**, which demonstrates running code on a remote node agent using a specific **node label/tag** and securely managing SSH credentials.

---

## 📌 Overview

The `SSH_agent_pipeline` allows Jenkins to execute commands on remote nodes using SSH keys. It ensures secure deployments and remote code execution while leveraging Jenkins agent labels to target specific nodes.

---

## 🛠️ Pipeline Stages

| Stage            | Description                                                              |
| ---------------- | ------------------------------------------------------------------------ |
| Checkout         | Pulls code from the Git repository.                                      |
| SSH Setup        | Uses Jenkins SSH Agent plugin to inject SSH credentials.                 |
| Remote Execution | Runs scripts or commands on the remote node identified by the tag/label. |
| Next Steps       | Optional build, test, or deployment after remote execution.              |

---

## 🚀 Getting Started

### Prerequisites

* Jenkins installed and running
* Git plugin enabled
* SSH Agent plugin installed in Jenkins
* SSH key credentials configured in Jenkins
* Node agent configured with the required label/tag
* Access to the repository containing the code

### Steps to Run

1. Clone the repository:

```bash
git clone https://github.com/Sanket006/Jenkins.git
```

2. Open Jenkins and create a new pipeline job.
3. Copy the `Jenkinsfile` from `SSH_agent_pipeline` folder.
4. Paste it into the pipeline configuration.
5. Update the node label and SSH credentials in the Jenkinsfile.
6. Run the pipeline.

### Example Jenkinsfile Snippet

```groovy
pipeline {
    agent { label 'remote-node-tag' }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanket006/Jenkins.git', branch: 'main'
            }
        }
        stage('Run on Remote Node') {
            steps {
                sshagent(['ssh-credentials-id']) {
                    sh 'ssh -o StrictHostKeyChecking=no user@remote-node "cd /path/to/project && ./run.sh"'
                }
            }
        }
    }
}
```

---

## ⚙️ Customization

* Replace `remote-node-tag` with the actual Jenkins node label.
* Use the correct SSH credentials ID configured in Jenkins.
* Modify remote commands or scripts as needed.
* Add additional stages like build, test, or deploy.

---

## 🤝 Contributing

Contributions are welcome! Fork the repo, enhance remote execution, and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.
