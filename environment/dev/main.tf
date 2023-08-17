provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXTMT4TRMJO2PCOUQ"
  secret_key = "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"
}


module "s3" {
  source      = "../../modules/s3"
  bucket_name = ["rakeshnull", "rahulnull", "shubhamnull", "swapnilnull"]
  env         = "dev"
}

module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"                                   #string
  private_subnet_cidr = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"] #list
  public_subnet_cidr  = ["10.0.48.0/20"]                                #list
  availability_zone   = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  env                 = "dev"
  ns                  = "iata"
  tags = {
    data-center = "mumbai"
    owner       = "iata"
    cost-center = "iata-cost-0012"
    mail-id     = "iata@abc.com"
  }
}


