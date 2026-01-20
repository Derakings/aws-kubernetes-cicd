#!/bin/bash

# Ref - https://www.jenkins.io/doc/book/installing/linux/
# Installing jenkins on Amazon Linux 2023
sudo dnf install wget -y

# Add required dependencies for the jenkins package (Install Java 17 - LTS and stable)
sudo dnf install java-17-amazon-corretto-devel -y
sudo dnf install fontconfig -y

# Configure Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2025.key

# Update dnf cache and install Jenkins
sudo dnf update -y
sudo dnf install jenkins -y

# Configure and start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to start
sleep 10
sudo systemctl status jenkins

# Ref - https://www.atlassian.com/git/tutorials/install-git
# Installing git
sudo dnf install -y git
git --version

# Installing Docker 
# Ref - https://docs.aws.amazon.com/linux/al2023/ug/docker.html
sudo dnf update -y
sudo dnf install docker -y

sudo usermod -a -G docker ec2-user
sudo usermod -aG docker jenkins

# Add group membership for the default ec2-user so you can run all docker commands without using the sudo command:
id ec2-user

sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service

sudo chmod 666 /var/run/docker.sock

# Restart Jenkins to apply docker group membership
sudo systemctl restart jenkins

# Run Docker Container of Sonarqube
docker run -d  --name sonar -p 9000:9000 sonarqube:lts-community

# Installing AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo dnf install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Ref - https://developer.hashicorp.com/terraform/cli/install/yum
# Installing terraform
sudo dnf install -y yum-utils
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf -y install terraform

# Verify terraform installation
terraform --version

# Ref - https://pwittrock.github.io/docs/tasks/tools/install-kubectl/
# Installing kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl installation
kubectl version --client

# Installing Trivy
# Ref - https://aquasecurity.github.io/trivy-repo/
RPM_ARCH="$(uname -m)"
sudo tee /etc/yum.repos.d/trivy.repo << EOF
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/${RPM_ARCH}/
gpgcheck=0
enabled=1
EOF

sudo dnf -y install trivy

# Verify trivy installation
trivy --version

# Installing Helm
# Ref - https://helm.sh/docs/intro/install/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh

# Verify helm installation
helm version
