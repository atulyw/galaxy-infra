variable "vpc_cidr" {
  type        = string
  description = "vpc cidr values"
}

variable "instance_tenancy" {
  type        = string
  description = "value"
  default     = "dedicated"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "value"
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "ns" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "availability_zone" {
  type    = list(any)
  default = []
}