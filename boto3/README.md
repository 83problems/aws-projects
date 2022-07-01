# AWS with Boto3

This directory stores Python/Boto3 files to provision AWS resources. The Python/Boto3 files here are the base requirements to run other modules. Each directory is a seperate module and can be ran by running `python` on the module. Each module has a README to describe how it works.

## Prerequisites

- An [AWS account](https://aws.amazon.com/account/ "AWS account")
- [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation "Boto3")
- A domain name registered with Amazon Route 53
- Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables
```shell
$ export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY ID"
$ export AWS_SECRET_ACCESS_KEY="YOUR SECRET ACCESS KEY"
```

## Features

* The base configuration will create a VPC with two subnets in two Availability Zones. The public subnet has an Internet Gateway and the private subnet has a NAT Gateway.

## Usage

To build the projects with Python/Boto3 follow these steps.

1. Update `config.ini` with domain_name, region_name, and profile_name.

2. Create virtual Python environment.

   `pytyon -m venv venv`

3. Source virtual Python environment.

   `source ./venv/bin/activate`

4. Install Python modules from `requirements.txt`.

   `pip install -r requirements.txt`

5. Install baseline AWS project.

   `python aws_baseline.py`
