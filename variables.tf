variable "aws_access_key" {
    description = "AWS access key"
}

variable "aws_secret_key" {
    description = "AWS secret key"
}

variable "key_pair_use" {
    description = "Key pair to use for SSH in us-east-1"
}

variable "key_pair_usw" {
    description = "Key pair to use for SSH in us-west-2"
}

variable "key_pair_euw" {
    description = "Key pair to use for SSH in eu-west-1"
}
