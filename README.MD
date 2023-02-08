# Project Description / Motivations
I got the idea for this project when I was looking through some azure load balancer documentation, and saw that azure LB does not support a container instance backend. I looked through the services that it does support, and saw that virtual machine scale sets were one of them. I thought to myself that it has been a while since I used VMSS, probably haven't used them since I was working on the AZ-104. So, I wanted to build a project that used VMSS, and utilizes some other cloud / devops technologies.

At the same time, I have recently been working on learning to develop using MERN. I have always had an interest in learning web development, to use it as a tool to allow me to build more advanced projects, and help me support applications in the work environment. I figured this would be the perfect project for me to host the code I have been working on. 

# Technologies used 
🛠 Azure Load Balancer 

🛠 Azure Container Instances

🛠 Github Actions 

🛠 Cosmo DB 

🛠 Azure Virtual Machine Scale Sets

🛠 Terraform 

🛠 Packer 

🛠 Node js + React js 


# Architecture 

![Architecture](/Architecture.png?raw=true "Architecture")


# CI/CD process
The CI/CD tool used for this project was Github Actions. This repository contains 4 pipelines (Frontend-CI, Frontend-CD, Backend-CI, Backend-CD). For this project the first deployment of the application is fairly manual, and documented below.

### CI  
For both frontend and backend CI, they will trigger on a push to every branch accept main, if a file has changed in each directory. This is because no code should get directly committed and pushed to the main branch. For all code changes, a new branch should be checked out to work on. 

I haven't written any tests for my code (still learning web dev), so the CI processes are as follows:

Frontend:
- checkout code
- setup node
- run a test build

Backend:
- checkout code
- setup packer
- validate the packer template


Below is an example scenario that would trigger the pipelines.

example:
1. developer creates a new branch 
2. developer makes changes to the frontend code, or backend code
3. developer commits + pushes the code 
4. pipeline would be triggered (if changes are made to both frontend and backend code, both trigger)

### CD 
For both frontend and backend CD, they trigger on a closed pull request to the main branch, if a file has changed in each directory. for this project, I am just assuming that feature branching will be used. Meaning, each feature will be developed on a branch and when complete, it's merged back into main. the CD processes are as follows.

Frontend: 
- checkout code
- login to azure
- login to ACR 
- build the docker image
- rollout the new ACI container 

Backend:
- checkout code
- setup packer
- login to azure
- build the packer image with the PR number as the unique identifier 
- trigger a rolling update via azCli 

    NOTE: this is not an official action, this is a run action that parses the output of an az cli command and uses JQ to parse / provide the id of the new image



Below is an example scenario that would trigger the pipelines
1. pull request is merged and code is pushed onto the main branch  


# Steps to try on your own 

 Fork the repository 

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

3. deploy the terraform resources in the Terraform/infra directory
    - this deploys the underlying infrastructure (CosmosDB, Virtual Network, Security Groups)
``` 

cd Terraform/infra 
terraform init 
terraform plan 
terraform apply -auto-approve 

```

4. get the CosmosDB password, and URL from the azure console, add that password to backend/config/default.json

    example of what the file should look like

    ```
    {
    "db": {
        "username": "mern-app-demo",
        "password": "longpassword",
        "url": "mongodb://url-for-db.mongo.cosmos.azure.com:10255/users?ssl=true&replicaSet=globaldb"
        }
    }
    ```

5. create an azure service principal 

    ``` 
    az ad sp create-for-rbac --name $name --role $role --scope /subscriptions/{subID}
    ```

6. export the required environment variables for the packer template, to build the template locally (you can hardcode them if you want)

```
 export AZURE_CLIENT_ID=" "
 export AZURE_CLIENT_SECRET=" " 
 export AZURE_TENANT_ID=" "
 export AZURE_SUB_ID=" "
 export PR=" " (just set this to a string like "starter-image")
```

Build the packer image

``` 
packer build app-image.json 
``` 

** Copy the image ID output from the packer build

7. build the frontend container locally 

``` 
cd frontend 
```

``` 
docker build -f Dockerfile.prod -t mernvmss.azurecr.io/mern-frontend:v1.0 . 
```

8. login to azure ACR 

``` 
az acr login --name mernvmss 
``` 

9. push the initial frontend container 

``` 
docker push mernvmss.azurecr.io/mern-frontend:v1.0 
```

10. get the following information and add to the terraform variable file in Terraform/app

    - packer image ID
    
11. get the following information and add to the terraform variable file in Terraform/frontend

 - azure container registry server name

        ``` 
        az acr show --name mernvmss | jq '.loginServer' 
        ```

    - azure container registry admin username

        ``` 
        az acr credential show --name mernvmss --resource-group mern-app | grep username 
        ``` 

    - azure container registry admin password 

        ``` 
        az acr credential show --name mernvmss --resource-group mern-app | jq '.passwords[0].value' 
        ```
    - container image name 

    NOTE: in production, don't store these values in plain text, create them as azure key value secrets


12. deploy the terraform code for the application

``` 
cd Terraform/app 
terraform init 
terraform plan 
terraform apply -auto-approve 
```

13. once the application layer is deployed, get the frontend ip address of the load balancer, add the IP to frontend/src/config/config.json
    - the file should look like this 

    ```
    { 
    "SERVER_URL": "http://20.12.242.10"
    }
    ```

14. deploy the frontend terraform 

```
cd Terraform/frontend
terraform init
terraform plan
terraform apply 
```

15. the application should be fully deployed at this point, if you want to test the CI/CD portion, continue to the next set of instructions.

    - if you want to destroy the application, skip to the bottom

# setup for CI/CD

1. set the required secrets for github actions repository 
    - use the same azure service principal as you did to build the initial packer image

    - AZURE_CLIENT_ID - service principal client ID
    - AZURE_CLIENT_SECRET - client secret
    - AZURE_SP_CREDENTIALS - This can be the entire json output you got from the azCli when you created the service principal
    - AZURE_SUB_ID - subscription id 
    - AZURE_TENANT_ID - tenant id
    - ACR_PASSWORD - azure container registry password
    - ACR_USERNAME - azure container registry password

example of AZURE_SP_CREDENTIALS

```
{
   "clientId": "<GUID>",
   "clientSecret": "<STRING>",
   "subscriptionId": "<GUID>",
   "tenantId": "<GUID>",
   "resourceManagerEndpointUrl": "<URL>"
   (...)
 }
 ```

 2. checkout a new branch 

 ``` git checkout -f trigger-deploy ``` 

 3. make a change to the frontend code, or backend code

 ``` 
 this can just be adding a line to a file in those directories
 ```

 4. push your code change 

 5. create a pull request 

 6. merge the pull request 

 7. monitor your pipelines running 

 8. done



 # Destroying the project
1. destroy the frontend terraform

```
cd Terraform/frontend
terraform destroy -auto-approve
```

2. destroy the application terraform 

    - NOTE: there is some weird behavior where it's going to fail to delete the health probe, but if you just run ``` terraform destoy ``` again, it will work
```
cd Terraform/app
terraform destroy -auto-approve
```

3. destroy the underlying infrastructure
```
cd Terraform/infra
terraform destroy -auto-approve
```

