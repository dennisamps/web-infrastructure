variable "region" {
  type = string
  default = "us-east-1"
}

variable "profile" {
  default = "sandbox"
  type = string
}

variable "cidr_base" {
  default = "10.0."
  type = string
  
}