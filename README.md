# Web Hosting Infrastructure

This is a proof of concept, automating the provisioning of infrastructure for managing, hosting and scaling an enterprise ready application and system, using Infrastructure as Code. 

## **Requirements**

To be able to spin up this terraform project you will require:
* AWS account
* Hosted zone / domain in Route 53 (e.g. example.co.uk)

## Infrastructure as Code (Terraform)

This infrastructure is deployed using ECS (EC2 service), with autoscaling of the containers and the instance host. CloudWatch monitoring has also been configured and is stored in S3. The topology diagram for this infrastructure can be found here:

[Web Hosting Architecture](network-diagram.jpg)

## How to deploy

Below are the sequence of steps required to deploy this project.

### Connecting to AWS using Access ID and Secret Access ID.

To connect to AWS run the commands below in your terminal:

```
export AWS_ACCESS_KEY_ID=<your access key ID>
export AWS_SECRET_ACCESS_Key=<you secrect access key>
```

or if you have the credentials and profile already set up you can just export the profile:

```
export AWS_PROFILE=<name of profile>
```

Now you can clone this git repo.

### S3

Navigate to the **S3 folder**.

First you need to set up an S3 bucket to be the backend, this is where the remote state files will be stored. 

Pay attention to the variables in `terraform.tfvars` and `provider.tf` files.

The variables that need to be changed are summarised in the table below:

| Variable    | File Name   | Notes       |
| ----------- | ----------- | ----------- |
| region      | terraform.tfvars| Enter the region you want to deploy infrastructure to|
| bucket-name   | terraform.tfvars & provider.tf | The bucket name has to be globally unique|

Commands to apply once the updates are completed:

```
terraform init
terraform plan --out plan
terraform apply plan
```

### ACM (Amazon Certificate Manager)

Naviage to the **acm** folder.

First you need to apply changes to some variables to create an AWS certificate to allow HTTPS encryption-in-flight. The variables that need updating is summarised in the table below:

| Variable    | File Name   | Notes       |
| ----------- | ----------- | ----------- |
| region      | terraform.tfvars| enter the region you want to deploy infrastructure to|
| zone_name      | terraform.tfvars| This should be you domain stored in Route 53 e.g. example.com|
| bucket   | provider.tf | The bucket name has to be globally unique, it should be the same one you set in the s3 stage|

Commands to apply once the updates are completed:

```
terraform init
terraform plan --out plan
terraform apply plan
```

### VPC 

Naviage to the **vpc** folder.

Update the following variables if required:

| Variable    | File Name   | Notes       |
| ----------- | ----------- | ----------- |
| region      | terraform.tfvars| enter the region you want to deploy infrastructure to|
| bucket   | provider.tf | The bucket name has to be globally unique, it should be the same one you set in the s3 stage|

Commands to apply once the updates are completed:

```
terraform init
terraform plan --out plan
terraform apply plan
```

### ECS 

Naviage to the **ecs** folder.

Update the following variables if required:

| Variable    | File Name   | Notes       |
| ----------- | ----------- | ----------- |
| region      | terraform.tfvars| enter the region you want to deploy infrastructure to|
| bucket   | provider.tf | The bucket name has to be globally unique, it should be the same one you set in the s3 stage|
| ami  | terraform.tfvars | The ami ID for the ecs instance image for your specified region|
| instance-type  | terraform.tfvars | t2-micro is sufficeint for this proof of concept|
| zone_name  | terraform.tfvars | This should be you domain stored in Route 53 e.g. example.com|
| a-record-domain-name  | terraform.tfvars | the subdomain you want people to access you rsite through e.g. dennis.example.com|

Commands to apply once the updates are completed:

```
terraform init
terraform plan --out plan
terraform apply plan
```



