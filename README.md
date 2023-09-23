# Ultimate_Pipeline
Jenkins and Argo CICD

-- Working on adding load balancer and hosted zone to the configuration --

This Terraform configuration automates the setup of a CICD pipeline using Jenkins, Docker, and SonarQube. The following steps outline how to finalize the setup:

## Prerequisites
- Terraform installed on your local machine.
- AWS CLI configured with the necessary credentials.
- An EC2 instance where Jenkins, Docker, and SonarQube will be deployed.
- A GitHub repository containing the code to be built and deployed.

## Steps

1. **Create Admin Account in Jenkins:**

   After provisioning the EC2 instance, SSH into it and create an admin account for Jenkins:

   ```bash
   Connect to <IP>:8080
   cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

   Follow the on-screen instructions to complete the Jenkins setup.

2. **Install Suggested Plugins:**

   After Jenkins is up and running, log in and install the suggested plugins.

3. **Add Admin User:**

   Create an admin user account if not already created.

4. **Install Docker Pipeline and SonarQube Scanner Plugin:**

   Install the Docker Pipeline and SonarQube Scanner plugins from the Jenkins plugin manager.

5. **Add Credentials:**

   - **github:** Generate a developer token for authenticating with GitHub.
   - **docker-cred:** Provide Docker Hub username and password.
   - **sonarqube:** Generate a token from the Security tab under My Account in SonarQube.

6. **Create Pipeline:**

   - Repo URL: `https://github.com/hyferdev/Jenkins-Zero-To-Hero`
   - Branch: `*/main`
   - Jenkinsfile path: `java-maven-sonar-argocd-helm-k8s/spring-boot-app/Jenkinsfile`

7. **Confirm Maven Installation:**

   Make sure that Maven is installed at `<IP>:8010` (replace `<IP>` with your instance's IP address).

8. **Update SonarQube Credentials:**

   Update SonarQube credentials at `<IP>:9000` (replace `<IP>` with your instance's IP address).

## Notes

- This Terraform configuration automates the setup of infrastructure components, but manual steps are required to set up Jenkins, Docker, and SonarQube.
- Ensure that your EC2 instance is properly configured and accessible over SSH.
- Make sure the GitHub repository contains the necessary code and the specified Jenkinsfile path is correct.
- Adjust any IP addresses or paths as needed to match your specific setup.

For more detailed instructions on setting up Jenkins, Docker, SonarQube, and the CICD pipeline, refer to the respective documentation for each tool.
