variable "amazon_linux_ami" {
  description = "Amazon Linux AMI search string"
  default = "amzn-ami-hvm-*-x86_64*"
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

variable "allow_ssh" {
}

variable "allow_tls" {
}

variable "instance_type" {
}
