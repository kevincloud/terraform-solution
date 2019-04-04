output "us-east-ip" {
    value = "${module.nginx-cdn.us-east-ip} / ${module.nginx-cdn.us-east-private-ip}"
}

output "us-east-host" {
    value = "${module.nginx-cdn.us-east-host}"
}

output "us-west-ip" {
    value = "${module.nginx-cdn.us-west-ip} / ${module.nginx-cdn.us-west-private-ip}"
}

output "us-west-host" {
    value = "${module.nginx-cdn.us-west-host}"
}

output "eu-west-ip" {
    value = "${module.nginx-cdn.eu-west-ip} / ${module.nginx-cdn.eu-west-private-ip}"
}

output "eu-west-host" {
    value = "${module.nginx-cdn.eu-west-host}"
}

output "webserver-private-ip" {
    value = "${aws_instance.webserver.0.private_ip}"
}
