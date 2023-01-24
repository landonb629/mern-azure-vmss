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
I got the idea for this project when I was looking through some azure load balancer documentation, and saw that azure LB does not support a container backend. I looked through the services that it does support, and saw that virtual machine scale sets were one of them. I thought to myself that it has been a while since I used VMSS, probably haven't used them since I was working on the AZ-104. So, I wanted to build a project that used VMSS, and utilizes some other cloud / devops technologies.

At the same time, I have recently been working on learning to develop using MERN. I have always had an interest in learning web development, to use it as a tool to allow me to build more advanced personal projects, something more then just a "hello world" HTML page. I figured this would be the perfect project for me to host the code I have been working on. 





