# Ultimate Pipeline
![228301952-abc02ca2-9942-4a67-8293-f76647b6f9d8 (1)](https://github.com/hyferdev/Ultimate_Pipeline/assets/125156467/7f7aa554-bd78-430e-804d-fff14e29718f)

This Terraform configuration automates the setup of a CICD pipeline using Jenkins, Docker, and SonarQube. We are utilizing ArgoCD to pull images to a Kubernetes cluster. Credit to [Abhishek Veeramalla](https://github.com/iam-veeramalla) for the initial Jenkins config files. The following steps outline how to finalize the setup:

**Click the headers for a step-by-step youtube video**

## [Prerequisites](https://youtu.be/IkYkUJjqqqA?si=gFHXAX2JPATWknC1)
- Terraform installed on your local machine.
- AWS CLI configured with the necessary credentials.
- An EC2 instance where Jenkins, Docker, and SonarQube will be deployed.
- A GitHub repository containing the code to be built and deployed.
- A clone/fork of my iteration of Jenkins-Zero-To-Hero project

#### Terraform Deployment

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/hyferdev/Ultimate_Pipeline
   ```

2. Navigate to the cloned directory:

   ```bash
   cd Ultimate_Pipeline
   ```

3. Review the Terraform configuration files in the `terraform` directory. Modify the files as per your requirements, such as the cloud provider, region, cluster size, or any other desired configuration.

4. Initialize Terraform and download the necessary provider plugins:


   ```bash
   terraform init
   ```

5. Review and validate the Terraform execution plan:

   ```bash
   terraform plan
   ```

   Ensure that the plan output matches your expectations and that no errors or warnings are present.

6. Apply the Terraform configuration to create the Kubernetes cluster:

   ```bash
   terraform apply
   ```

   Confirm the deployment by typing `yes` when prompted. The provisioning process may take several minutes, depending on your infrastructure size.

#### Cleaning Up

To remove the Jenkins VM and associated resources, you can use Terraform to destroy the infrastructure:

```bash
terraform destroy
```

When prompted, type `yes` to confirm the destruction. Be cautious, as this action is irreversible and will delete all resources created by Terraform.


## [Jenkins Steps](https://youtu.be/lKJZAWns-FI?si=KEx5SBHAeiCMBVx_)

1. **Create Admin Account in Jenkins:**

   After provisioning the EC2 instance, SSH into it to pull initial admin credentials account for Jenkins:

   ```bash
   cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

   Connect to <IP>:8080 and follow the on-screen instructions to complete the Jenkins account setup.

2. **Install Suggested Plugins:**

   After Jenkins is up and running, log in and install the suggested plugins.

4. **Install Docker Pipeline and SonarQube Scanner Plugin:**

   Install the Docker Pipeline and SonarQube Scanner plugins from the Jenkins plugin manager.

5. **Confirm SonarQube Installation:**

   Update SonarQube credentials at `<IP>:9000` (replace `<IP>` with your instance's IP address).
   Update java-maven-sonar-argocd-helm-k8s/spring-boot-app/JenkinsFile with SonarQube IP

6. **Confirm Maven Installation:**

   Make sure that Maven is installed at `<IP>:8010` (replace `<IP>` with your instance's IP address).

7. **Add Credentials to Jenkins:**

   - **github:** Generate a developer token for authenticating with GitHub.
   - **docker-cred:** Provide Docker Hub username and password.
   - **sonarqube:** Generate a token from the Security tab under My Account in SonarQube.

6. **Create Pipeline:**

   - Repo URL: `https://github.com/hyferdev/Jenkins-Zero-To-Hero`
   - Branch: `*/main`
   - Jenkinsfile path: `java-maven-sonar-argocd-helm-k8s/spring-boot-app/JenkinsFile`
  
Done! At this point you should be able to run your build with no errors if configured correctly.

## [ArgoCD Steps](https://youtu.be/RMjnkyB6EJs?si=2mZBDAcOSrRx1vcJ)

1. **Run the Minikube installation script and provide a username for managing Minikube:**

```bash
./minikube_install.sh
```

2. **Start Minikube:**

```bash
minikube start
```

3. **Run the ArgoCD operators installation script. It will provide the initial ArgoCD password:**

```bash
./argocd_install.sh
```

4. **Expose ArgoCD ports to connect locally:**

```bash
minikube service argocd-server &
```

5. **Open a web browser on the same subnet and access the ArgoCD URL. Sign in with the default username "admin" and the password received from the ArgoCD installation.**

6. **Configure a new app in ArgoCD with the following configs(Any name can be used and namespace has to already exists):**

- **Name:** hyfer
- **Project Name:** default
- **Sync:** Automatic
- **URL:** [https://github.com/hyferdev/Jenkins-Zero-To-Hero](https://github.com/hyferdev/Jenkins-Zero-To-Hero)
- **Path:** java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests
- **Cluster URL:** default
- **Namespace:** default

**Done! You've now set up ArgoCD to manage your Kubernetes cluster.**

## Notes

- This Terraform configuration automates the setup of infrastructure components, but manual steps are required to set up Jenkins, Docker, and SonarQube.
- Ensure that your EC2 instance is properly configured and accessible over SSH.
- Make sure the GitHub repository contains the necessary code and the specified Jenkinsfile path is correct.
- Adjust any IP addresses or paths as needed to match your specific setup.

For more detailed instructions on setting up Jenkins, Docker, SonarQube, and the CICD pipeline, refer to the respective documentation for each tool.

## Contributions

Contributions to this project are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and distribute it as needed.

