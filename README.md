# Web Hosting Infrastructure

This is a proof of concept, automating the provisioning of infrastructure for managing, hosting and scaling an enterprise ready application and system, using Infrastructue as Code. 

## **Requirements**

To be able to spin up this terraform projects you will require:
* AWS account
* Hosted zone / domain in Route 53 (e.g. example.co.uk)

## Infrastructure as Code (Terraform)

This infrastructure is deployed using ECS (EC2 service), with autoscaling of the containers and the instance host. CloudWatch monitoring has also been configured and is stored in S3. The topoplogy diagram for this infrastructure can be found here:

[Web Hosting Architecture]

## How to deploy

Below are the sequence of steps required to deploy this project.

### Connecting to AWS using Access ID and Secret Access ID.

To connect to AWS run the commands below in your terminal:

...
export AWS_ACCESS_KEY_ID=<your access key ID>
export AWS_SECRET_ACCESS_Key=<you secrect access key>
...





You have been asked to create a website for a modern company that has recently migrated
their entire infrastructure to AWS. They want you to demonstrate a basic website with some text
and an image, hosted and managed using modern standards and practices in AWS.
You can create your own application, or use open source or community software. The proof of
concept is to demonstrate hosting, managing, and scaling an enterprise-ready system. This is
not about website content or UI.
