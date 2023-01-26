[x] application code
[x] application architecture
[x] terraform code
[x] frontend CI/CD
[x] backend CI/CD
[x] terraform for the azure static web application
[] final test: start -> finish

going to handle secrets with environment variables instead of having to find a secret store

NEED TO ADD 
- add the client secret to have access to pull the list of VM images

steps:
1. az login 
2. create an azure service principal 
3. packer build the starter image
4. deploy the baseline terraform 
5. change the environment variables for the application in github actions or going to have to hardcode the values for now 
6. change the frontend URL in the code (I know this sucks, this wasn't supposed to be highlighting that I am an expert developer)


# Project Description / Motivations
I got the idea for this project when I was looking through some azure load balancer documentation, and saw that azure LB does not support a container instance backend. I looked through the services that it does support, and saw that virtual machine scale sets were one of them. I thought to myself that it has been a while since I used VMSS, probably haven't used them since I was working on the AZ-104. So, I wanted to build a project that used VMSS, and utilizes some other cloud / devops technologies.

At the same time, I have recently been working on learning to develop using MERN. I have always had an interest in learning web development, to use it as a tool to allow me to build more advanced personal projects, something more then just a "hello world" HTML page. I figured this would be the perfect project for me to host the code I have been working on. 

# Technologies used 
🛠 Azure Load Balancer 

🛠 Azure Static Web Apps 

🛠 Github Actions 

🛠 Cosmo DB 

🛠 Azure Virtual Machine Scale Sets

🛠 Terraform 

🛠 Packer 

🛠 Node js + React js 


# Architecture 

![Architecture](/Architecture.png?raw=true "Architecture")




# Steps to try on your own 
- Fork the repository 

1. az login 

2. Create a storage account and container for your terraform backend (using az CLI)

export your environment variables 
```
export storageAccountName=''
export resourceGroupName=''
export containerName=''
export location=''
```

create the resource group 
```
az group create --name $resourceGroupName --location $location 
```

create the storage account 
```
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location eastus --sku Standard_LRS --kind StorageV2
```

create storage account container 
```
az storage container create --name $containerName --account-name $storageAccountName --auth-mode login
```

3. create an azure service principal
``` az ad sp create-for-rbac --name $name --role $role --scope /subscriptions/{subID}/resourceGroups/{rgGroups} ```

4. export the required environment variables for the packer template (you can hardcode them if you want), create

    - AZURE_CLIENT_ID
    - AZURE_CLIENT_SECRET
    - AZURE_TENANT_ID
    - AZURE_SUB_ID 
    - GITHUB_SHA (just set this to a string like "starter-image")

``` packer build packer-default.json ``` 

5. get the ID of the image that you just built, add that to the terraform variable "image_id"

6. deploy the terraform code 
``` cd Terraform ```

``` terraform init ```

``` terraform plan ```

``` terraform apply -auto-approve ```


7. set all the required secrets for github actions repository 

    - AZURE_CLIENT_ID
    - AZURE_CLIENT_SECRET
    - AZURE_SP_CREDENTIALS
    - AZURE_STATIC_WEBAPP_NAME
    - AZURE_SUB_ID
    - AZURE_TENANT_ID

az staticwebapp secrets list --name mern-frontend  | jq -r .properties.apiKey



## NEED TO DO AN NSLOOKUP ON THE AZURE WEB APP AND THEN JUST ALLOW THOSE THROUGH THE FIREWALLS
## MAKE SURE THAT SELECTED NETWORKS IS ENABLED FOR COSMOSDB







