variable "amazon_linux_ami" {
  description = "Amazon Linux AMI search string"
  default = "amzn2-ami-hvm-*-gp2"
}

variable "disk_size" {
  description = "Disk size for root volume"
  type    = number
  default = 50
}

variable "ebs_disk_size" {
  description = "Disk size for EBS volume"
  type    = number
  default = 50
}

variable "aws_region" {
}

variable "subnet" {
}

variable "simple_website_sg" {
}

variable "instance_type" {
}

variable domainname {
}
