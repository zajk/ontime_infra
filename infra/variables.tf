variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_azs" {
    default = {
        "0" = "us-east-1a"
        "1" = "us-east-1b"
        "2" = "us-east-1d"
    }
}

variable "aws_amis" {
    default = {
        eu-west-1 = "ami-b1cf19c6"
        us-east-1 = "ami-9a562df2"
        us-west-1 = "ami-3f75767a"
        us-west-2 = "ami-21f78e11"
    }
}

variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
    default = "deployer-key"
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
    default = "~/.ssh/id_rsa"
}