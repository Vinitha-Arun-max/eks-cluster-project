#!/bin/bash

set -e

yum update -y

# Install Java (Required for jenkins)

sudo yum install java-17-amazon-corretto -y

# Install Docker

amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker
usermod -aG  docker ec2-user

#Install Jenkins
sudo yum install -y wget
sudo yum install rpm -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins

#Install AWS CLI

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

#Install Terraform

TERRAFORM_VERSION="1.6.6"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip
unzip -q /tmp/terraform.zip -d /usr/local/bin/
chmod +x /usr/local/bin/terraform

#install kubectl

curl -LO "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

#Enable services

systemctl restart docker
systemctl restart jenkins
