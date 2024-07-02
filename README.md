# Visitor Counter App

## Overview

This application counts the number of unique visitors and displays this statistic. The backend is developed with Flask (Python) and uses PostgreSQL as the database.

## Technologies Used

- Flask (Python)
- PostgreSQL
- Docker
- Docker Compose
- Terraform
- GithubAction
- Azure cloud

## How to Start the Service from Scratch:

### Prerequisites:

Docker and Docker Compose installed
Terraform installed
Azure CLI installed
GitHub account for repository management and CI/CD

### Steps:

1. Clone the repository:
```
git clone https://github.com/sahurtado88/Devops-ABB.git
```

2. Set Up Environment Variables:

Create a .env file with the necessary environment variables, such as database credentials and API keys.

3. Build and Run Docker Containers: 
to test this application locally use the next command

```
docker-compose up --build
```
4. Infraestructure execution

Set up the service principal credentials so Terraform can access and create the resources. Create an Azure Key Vault to store the admin username and password for the PostgreSQL database. Create a storage account to manage the backend Terraform state file.

To execute terraform apply, pass the tfvars file depending on the environment you want:
```
terraform init
terraform apply --var-file dev.tfvars -auto-approve 
```
There is a terraform.yml workflow that executes the Terraform script, and you can choose between the dev and prod environments.

5. Deploy application

Push your changes to the main branch, and GitHub Actions will automatically deploy the application to Azure.


## How to Scale Number of Servers:

To scale the number of servers, modify the infrastructure configuration in Terraform to increase the number of instances in the Azure App Service Plan.

Scale up: You can scale up by changing the pricing tier of the app service plan that your app belongs to.

Scale out: You can scale out based on traffic or specific rules, such as CPU usage percentage. Additionally, you can scale out according to a predefined schedule.

## What is application deployment architecture diagram

![](.\Counterapp.drawio.png)

In GitHub, we have a repository containing the application and a Dockerfile to containerize the Flask application. Through GitHub Actions, we build and publish the image to the Docker Hub repository. Once the image is ready, we deploy it to the Azure Web App service and use Azure Database for PostgreSQL to store the data. The Azure Web App service provides a URL to expose the application.



# Monitoring

Briefly explain how you would monitor your application, and what system you would use for it

To effectively monitor the application, the following strategies can be employed:

Azure Monitor: Configure diagnostics, metrics, and logs for App Service and PostgreSQL.
Application Insights: Integrate for deep monitoring of your App Service.
Alerts: Set up alerts to be notified of issues in real-time, such as high CPU usage.
Visualization: Create dashboards and alerts with Grafana.
