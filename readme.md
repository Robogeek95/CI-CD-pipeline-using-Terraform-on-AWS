# Prospa Assessment
## Overview

This project implements the infrastructure and CI/CD pipeline using Terraform on AWS. It deploys a scalable and secure architecture for hosting a web application and includes a robust CI/CD pipeline for automated building, testing, and deployment.

## Architecture

![architecture diagram](/assets/prospa-archi.jpg)

The architecture is based on AWS and consists of the following components:

### Public-facing Web App and Mobile App:

A containerized app Hosted using ECS. Utilizes Application Load Balancers (ALBs) and AWS WAF for traffic distribution and security.

### Backend App and Database:

The backend app is hosted in a private subnet within and also containerized using ECS. Leveraging Amazon RDS for MySQL v8 for managed database services.

### Environments:

Separate environments for `development`, `staging`, and `production`.
Each environment has its own resources for independent configuration, deployment and state.

### Terraform for Infrastructure as Code (IaC):

Infrastructure management using Terraform to define resources and configurations in a consistent and reproducible manner.

Asides provisioning the infrastructure, Terraform is also used to provison AWS codePipeline, codeBuild and CodeDeploy.

### CI/CD Pipeline:

Docker and ECS for containerization and orchestration. The Source code is hosted in a GitHub repository.

AWS CodePipeline builds, tests, and deploys the application based on changes in the repository.

### Database Management on AWS:

Amazon RDS is used for managing the MySQL v8 database. Provisioning RDS instances with desired capacity, security groups, and backup configurations.

## Project Structure

The project structure is organized as follows:

### main.tf: The main Terraform configuration file that defines the AWS provider, modules, and resources.

### variables.tf: Variable definitions file containing input variables used throughout the configuration.

### outputs.tf: Output definitions file containing the values that will be exposed after the infrastructure is provisioned.

### modules/: Directory containing reusable Terraform modules for different components of the infrastructure.

### buildspec.yml: Build specification file for CodeBuild, defining the build steps, environment, and artifacts.


