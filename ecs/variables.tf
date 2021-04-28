variable "region" {
  type = string
  default = "us-east-1"
}


variable "cidr_base" {
  default = "10.0."
  type = string
  
}

variable "ami" {
  type =string
}

variable "instance-type" {
  type = string
  
}


variable "zone_name" {
  type = string
}

variable "a-record-domain-name" {
  type = string
}

