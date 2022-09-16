variable "region-name" {
    description = "name of region"
    default = "eu-west-2"
    type = string
}

variable "cidr-for-vpc" {
    description = "the cidr for VPC"
    default = "10.0.0.0/16"
    type = string
}

variable "cidr-for-pub-1" {
    description = "the cidr for Test-public-sub1"
    default = "10.0.1.0/24"
    type = string
}

variable "cidr-for-pub-2" {
    description = "the cidr for Test-public-sub2"
    default = "10.0.2.0/24"
    type = string
}

variable "cidr-for-priv-1" {
    description = "the cidr for Test-private-sub1"
    default = "10.0.3.0/24"
    type = string
}

variable "cidr-for-priv-2" {
    description = "the cidr for Test-private-sub2"
    default = "10.0.4.0/24"
    type = string
}

variable "Pub-1-AZ" {
    description = "Public Subnet 1 availability zone"
    default = "eu-west-2a"
    type = string
}

variable "Pub-2-AZ" {
    description = "Public Subnet 2 availability zone"
    default = "eu-west-2b"
    type = string
}

variable "Priv-1-AZ" {
    description = "Private Subnet 1 availability zone"
    default = "eu-west-2a"
    type = string
}

variable "Priv-2-AZ" {
    description = "Private Subnet 2 availability zone"
    default = "eu-west-2b"
    type = string
}

variable "internet-gateway-association" {
    description = "association of internet gateway with route"
    default = "0.0.0.0/0"
    type = string
  }

variable "elastic-ip" {
    description = "elastic ip for NAT Gateway"
    default = "10.0.0.3"
    type = string
  }

 
variable "nat-gateway-destination-cidr-block" {
    description = "destination route for nat gateway"
    default = "0.0.0.0/0"
    type = string
  }