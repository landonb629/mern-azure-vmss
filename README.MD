# Project Description / Motivations
The idea for this project came from looking at some azure load balancer documentation, I saw that azure LB doesn't support a container instance backend. I noticed that vm scale sets was one of the supported backends, It's been a very long time since I used them so, I wanted to build a project that utilized them! 

At the same time, I have recently been working on learning to develop using MERN. I have always had an interest in learning web development, mostly to use it as a tool to allow me to build more advanced projects, and help me support applications in a work environment. I figured this would be the perfect project for me to host the code I have been working on. 

# The code 
This is not "production" level code by any means. The code That is written for this application is to reinforce the concept of authentication for a fullstack application. Therefore, the functionality of this application is to do just that, log you in. Once you login, the application has no function.

some of the concepts that I wanted to test myself on with this project from a development standpoint are:
- password hashing 
- fetching / posting data to/from an API 
- state management 
- handling cookies on the frontend / backend

# Technologies used 
🛠 Azure Load Balancer 

🛠 Github Actions 

🛠 Cosmo DB 

🛠 Azure Virtual Machine Scale Sets

🛠 Terraform 

🛠 Packer 

🛠 Node js + React js 


# Architecture 

![Architecture](images/Architecture.png?raw=true "Architecture")


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
- build the frontend packer image
- trigger a vmss rolling update 

Backend:
- checkout code
- setup packer
- login to azure
- build the packer image with the PR number as the unique identifier 
- trigger a rolling update via azCli 

    NOTE: this is not an official action, this is a run action that parses the output of an az cli command and uses JQ to parse / provide the id of the new image

# Steps to try on your own 

 Fork the repository 

1. az login 

2. deploy the terraform resources in the Terraform/infra directory
    - this deploys the underlying infrastructure (CosmosDB, Virtual Network, Security Groups)
``` 

cd Terraform/infra 
terraform init 
terraform plan 
terraform apply -auto-approve 

```

3. get the CosmosDB password, with the command below, add that password to backend/config/default.json

    ```
    az cosmosdb keys list --name mern-app-demo --resource-group mern-app --type keys
    ```

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

4. create an azure service principal, with the role of contributor at the subscription level

    NOTE: you can get your subscription ID with the following command, copy the "id" 

    ```
    az account show 
    ```

    ``` 
    az ad sp create-for-rbac --name $name --role $role --scope /subscriptions/{subID} --sdk-auth
    ```

5. export the required environment variables for the packer template, to build the template locally (you can hardcode them if you want)

```
 export AZURE_CLIENT_ID=" "
 export AZURE_CLIENT_SECRET=" " 
 export AZURE_TENANT_ID=" "
 export AZURE_SUB_ID=" "
 export PR=" " (just set this to a string like "starter-image")
```

Build the packer images

``` 
cd packer
packer build app-image.json 
packer build frontend-image.json
``` 

** copy the outputted image IDs


6. get the following information and add to the terraform variable file in Terraform/app

    - api-image-id
    - frontend-image-id

7. deploy the terraform code for the application

``` 
cd Terraform/app 
terraform init 
terraform plan 
terraform apply -auto-approve 
```


14. the application should be fully deployed at this point, if you want to test the CI/CD portion, continue to the next set of instructions.

    - if you want to destroy the application, skip to the bottom

# How to check if the application is working?

1. locate the frontend IP address of your public load balancer
2. put the IP address in your browser 
3. type in a name, email, and password and click "register"
4. you should be redirected to a page that says "welcome to your home page"

# setup for CI/CD

1. set the required secrets for github actions repository 
    - use the same azure service principal as you did to build the initial packer image

    - AZURE_CLIENT_ID - service principal client ID
    - AZURE_CLIENT_SECRET - client secret
    - AZURE_SP_CREDENTIALS - This can be the entire json output you got from the azCli when you created the service principal
    - AZURE_SUB_ID - subscription id 
    - AZURE_TENANT_ID - tenant id

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

2. destroy the application terraform 

    - NOTE: there is some weird behavior where it's going to fail to delete the health probe, but if you just run ``` terraform destoy ``` again, it will work
```
cd Terraform/app
terraform destroy -auto-approve
```

make sure to delete the image that was created

3. destroy the underlying infrastructure
```
Manually delete the images that were build from CI/CD and local
cd Terraform/infra
terraform destroy -auto-approve
```
- 



