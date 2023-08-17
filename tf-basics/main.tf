terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = "us-east-1"
  access_key = "AKIAXTMT4TRMJO2PCOUQ"
  secret_key = "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"
}



resource "aws_s3_bucket" "this" {
  bucket = "rakesh-webapp-${var.env}"
  tags   = var.costcenter
}


variable "env" {
  type        = string
  default     = "dev"                                          #optional
  description = "this variable is used to set the environment" #optional
}

variable "bucket_names" {
  type    = list(string)
  default = ["ram", "shyam", "ujwesh", "rakesh", "rahul"]
  #            0         1       2          3        4
}


variable "create_bucket" {
  type    = bool
  default = false
}

variable "numbers" {
  type    = number
  default = 12
}

variable "costcenter" {
  type = map(string)
  default = {
    "name"       = "xyz"
    "region"     = "us-east-1"
    "location"   = "mumbai"
    "cost-cents" = "inbestment"
  }
}

variable "datacenter" {
  type = any
  default = {
    name     = ["a", "b", "c", "d"]
    "region" = "us-east-1"
    location = {
      "a" = "b"
      "c" = "d"
    }
    "cost-cents" = "inbestment"
  }
}

