variable "server_name" {
  description = "Name of the server"
  default = "nginx-cc"
}

variable "server_hostname" {
  description = "The FQDN or IP address of the web server to cache content for"
}

variable "vpc_id" {
    description = "VPC to create the nginx server in"
}

