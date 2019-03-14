# variable "aws_access_key" {}
# variable "aws_secret_key" {}
# variable "aws_key_path" {}
# variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for public subnet"
    default = "10.0.61.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.42.0/24"
}

variable "internet_cidr" {
    default = "0.0.0.0/0"
  
}

variable "amis" {
    default = "ami-08b08d6d"
  
}

variable "inst_type" {
    default = "t2.small"
  
}

variable "keyname" {
    default = "vm"
  
}




