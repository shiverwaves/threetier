#############################################
# network inputs                            #
#############################################

variable "region" {
  description = "The specified AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "The name used as an identifer for the project"
  type        = string
  default     = "test"
}

variable "vpc_cidr" {
  description = "The VPC network block in cidr X.X.X.X/Y"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "The Public Subnet network block in cidr X.X.X.X/Y"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_cidr" {
  description = "The Public Subnet network block in cidr X.X.X.X/Y"
  type        = string
  default     = "10.0.1.0/24"
}

#############################################
# app inputs                                #
#############################################
