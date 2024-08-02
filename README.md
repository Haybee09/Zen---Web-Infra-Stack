# Zen Web Infra Stack

# Azure Infrastructure Deployment using Terraform

This repository contains Terraform configuration files to deploy a scalable and secure infrastructure on Azure. The infrastructure includes a virtual network, subnets, network security groups, virtual machines, load balancer, application gateway, and Azure SQL Database.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version 0.12 or later)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active Azure subscription

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   
2. Log in to Azure using the Azure CLI:
    ```bash
    az login

3. (Optional) If you have multiple subscriptions, select the one you want to use:
    ```bash
    az account set --subscription="SUBSCRIPTION_ID"

4. Create a terraform.tfvars file in the repository-directory and add your specific variable value
    ```bash
    resource_group_name    = "Zen_Core"
    location               = "eastus 2"
    vnet_address_space     = ["10.0.0.0/16"]
    web_subnet_prefix      = "10.0.1.0/24"
    db_subnet_prefix       = "10.0.2.0/24"
    appgw_subnet_prefix    = "10.0.3.0/24"
    vm_admin_username      = "VM User"
    vm_admin_password      = "VEM Password"
    sql_admin_username     = "SQL User"
    sql_admin_password     = "SQL Password"
    project_name           = "zenrecovery"
    web_vm_count           = 2
    security_center_email  = "user@email"

5. Initialize Terraform:
    ```bash
    terraform init

6. Review Terraform plan:
    ```bash
    terraform plan

6. Apply Terraform configuration:
    ```bash
    terraform apply

Type 'yes' when prompted to create the resources.

### File Structure

- `main.tf`: Main configuration file
- `variables.tf`: Variable definitions
- `network.tf`: Network-related resources
- `compute.tf`: Virtual machine configurations
- `database.tf`: Azure SQL Database configuration
- `load_balancer.tf`: Azure Load Balancer configuration
- `application_gateway.tf`: Azure Application Gateway configuration
- `security.tf`: Security-related resources (Key Vault, Backup, Security Center)
- `outputs.tf`: Output values

### Customization
You can customize the deployment by modifying the variable values in terraform.tfvars or by editing the resource configurations in the respective .tf files.

### Destory Resources
     ```bash
    terraform destroy



