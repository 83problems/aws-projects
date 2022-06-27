# AWS with Terraform

This directory stores Terraform files to provision AWS resources. The Terraform files here are the base requirements to run other modules. Each directory is a seperate module and can be ran by adding the appropriate lines to `main.tf`. Each module has a README to describe how it works.

## Prerequisites

- An [AWS account](https://aws.amazon.com/account/ "AWS account")
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html "AWS CLI")
- A domain name registered with Amazon Route 53
- [Terraform](https://www.terraform.io/ "Terraform")
- Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables
```shell
$ export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY ID"
$ export AWS_SECRET_ACCESS_KEY="YOUR SECRET ACCESS KEY"
```
## Features

* The base configuration will create a VPC with two subnets in two Availability Zones. The public subnet has an Internet Gateway and the private subnet has a NAT Gateway. The Terraform state file is stored in S3 and lock file is controlled by DynamoDB.

## Usage

To build the projects with Terraform follow these steps.

1. Update `variables.tf` with your registered domain and region.

2. Add project to main.tf. For example, to add the EC2 website project add this:
    ```
    module "website_ec2_instance" {
      source = "./modules/aws-ec2-website"
      tags = {
        Terraform = "true"
      }
    }
    ```

3. Initialize Terraform.

   `terraform init`

4. Run terraform plan.

   `terraform plan`

5. Run terraform apply.

   `terraform apply`

6. Initialize Terrform again. This is required to build the backend.tf file to use S3.

   `terraform init`

7. When finished, destroy Terraform project. S3 bucket will need to be deleted manually.

   `terraform destroy`
