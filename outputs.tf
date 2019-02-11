output "ip_address_east" {
    value = "${module.nginx-east.ip_address}"
}

output "host_name_east" {
    value = "${module.nginx-east.host_name}"
}

output "ip_address_west" {
    value = "${module.nginx-west.ip_address}"
}

output "host_name_west" {
    value = "${module.nginx-west.host_name}"
}
