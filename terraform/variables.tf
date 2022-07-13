variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "domainname" {
  description = "Domain name"
  default     = "secondratedevshop.com"
}

variable "vpc_primary_cidr" {
  description = "CIDR block for Primary VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "s3_backend_key" {
  description = "S3 backend path"
  default     = "global/s3/terraform.tfstate"
}
