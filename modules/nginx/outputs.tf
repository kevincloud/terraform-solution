output "ip_address" {
    value = "${aws_instance.nginx_instance.public_ip}"
}

output "hostname" {
    value = "${aws_instance.nginx_instance.public_dns}"
}
