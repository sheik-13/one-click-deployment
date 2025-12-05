variable "vpc_cidr" {
  default = "10.16.0.0/16"
}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.16.1.0/24", "10.16.2.0/24"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.16.3.0/24", "10.16.4.0/24"]
}

variable "region" {
  default = "us-east-1"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "pub_route" {
  default = "0.0.0.0/0"
}

variable "pvt_route" {
  default = "0.0.0.0/0"
}

variable "ami" {
  default = "ami-0ecb62995f68bb549" # Ubuntu 24.04 LTS for us-east-1
}

variable "instance_type" {
  default = "t3.micro"
}

variable "project_name" {
  default = "apt-devops-assignment"
}
