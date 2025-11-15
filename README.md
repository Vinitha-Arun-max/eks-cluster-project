**Automated setup of an AWS EKS Cluster with CI/CD integration**

## Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Architecture](#architecture)
* [Repository Structure](#repository-structure)
* [Prerequisites](#prerequisites)
* [Getting Started](#getting-started)
* [Usage](#usage)
* [CI/CD Pipeline](#cicd-pipeline)
* [Cleanup / Tear-down](#cleanup--tear-down)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)

## Overview

This project provides **Infrastructure as Code (IaC)** and CI/CD pipeline to provision a fully-functional Kubernetes cluster on AWS using Terraform and Jenkins. The goal is to streamline the creation of an Amazon EKS cluster, configure deployment pipelines, and deploy a sample application (e.g., nginx) into the cluster automatically.

## Features

* Provision an EKS cluster with Terraform
* Create required AWS networking (VPC, subnets, security groups)
* Set up worker nodes / node groups for EKS
* Configure Jenkins server to perform CI/CD
* Jenkins pipeline to build, test, and deploy to EKS
* Deploy a sample Nginx application to verify cluster functionality
* Clean-up capability to destroy infrastructure when done

## Architecture

Here’s a high-level view of how components fit together:

```
User → Jenkins (CI/CD) → Terraform → AWS (VPC → EKS cluster) → Kubernetes workloads  
```

* Terraform code lives in the `ekscluster/` folder
* Jenkins server configuration lives in `jenkinsserver/`
* Jenkins pipeline definitions and scripts in `jenkinspipeline/`
* Sample application manifest lives in `nginx/`

## Repository Structure

```
├── ekscluster/            # Terraform code for EKS cluster and networking
├── jenkinsserver/         # Setup for Jenkins (master) node on AWS
├── jenkinspipeline/       # Jenkins pipeline jobs & scripts
├── nginx/                 # Sample application manifests (nginx deployment)
├── .gitignore             # Files/folders to ignore
```

## Prerequisites

Before you begin, ensure the following are in place:

* An AWS account with necessary permissions (IAM, EKS, EC2, VPC, etc)
* Terraform installed (version X.Y.Z or higher)
* AWS CLI configured (with `aws configure`)
* Jenkins server credentials / access (or ability to provision)
* kubectl and AWS-IAM-authenticator installed if you’ll access the cluster manually
* Basic knowledge of Kubernetes, AWS, Terraform, and Jenkins pipelines

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Vinitha-Arun-max/eks-cluster-project.git  
cd eks-cluster-project
```

### 2. Create the Infrastructure

Navigate to the `ekscluster/` directory, review and update `variables.tf` or other inputs (e.g., region, cluster name, node count), and then run:

```bash
terraform init  
terraform plan  
terraform apply
```

### 3. Jenkins Server Setup

Go to the `jenkinsserver/` directory and follow instructions (e.g., EC2 provisioning, security groups, install Jenkins, configure IAM roles). Once Jenkins is available:

* Install required plugins (e.g., Kubernetes, AWS, Git)
* Configure credentials (AWS, GitHub)
* Configure Kubernetes credentials / context for Jenkins

### 4. Configure CI/CD Pipeline

In `jenkinspipeline/`, review the `Jenkinsfile` and supporting scripts. In Jenkins:

* Create a new pipeline job pointing to this repository
* Ensure Jenkins has permission to access the EKS cluster and apply manifests
* Trigger the pipeline: this will build the sample image (if applicable), push it to a registry, update the Kubernetes manifest, and deploy to the cluster

### 5. Deploy Sample Application (nginx)

After pipeline execution, you can verify in the EKS cluster:

```bash
kubectl get nodes  
kubectl get deployments --namespace default  
kubectl get svc --namespace default  
```

You should see the `nginx` application deployed successfully.

## CI/CD Pipeline

* **Build stage:** fetch code, build container image (if applicable), push to registry
* **Deploy stage:** update Kubernetes manifest in `nginx/`, apply to EKS cluster
* **Verification stage:** ensure deployment succeeded (e.g., pod is running, service endpoint reachable)
* **Rollback / cleanup stage:** optionally destroy or roll back manifest on failure

## Cleanup / Tear-down

To destroy all resources created by Terraform:

```bash
cd ekscluster/
terraform destroy
```

Ensure that any additional AWS resources provisioned (Jenkins EC2, ECR images, etc) are also cleaned up to avoid ongoing charges.

> **Note:** You may need to customize some parts above (such as Terraform variable names, sample application details, Jenkins pipeline specifics, or license) to match exactly what is implemented.

Let me know if you’d like a more detailed section (e.g., View diagrams, sample YAML manifests, variables details, environment setups) and I can help extend 
