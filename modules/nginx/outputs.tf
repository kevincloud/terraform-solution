output "ip_address" {
    value = "${aws_instance.nginx_instance.public_ip}"
}

output "host_name" {
    value = "${aws_instance.nginx_instance.public_dns}"
}
