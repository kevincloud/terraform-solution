output "ip_address" {
    value = "${aws_instance.webserver.private_ip}"
}