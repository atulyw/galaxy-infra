variable "bucket_name" {
  type        = list(string) #required
  description = "variable for s3 bucker name"
}

variable "env" {
  type    = string
  default = "variable for environment"
}