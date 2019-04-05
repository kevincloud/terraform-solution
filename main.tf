provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

module "peered-vpcs" {
    source  = "app.terraform.io/kevinspace/peered-vpcs/aws"
    version = "1.0.12"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "webserver" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "m5.large"
    key_name = "kevin-sedemos"
    vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]
    user_data = "${data.template_file.user_data.rendered}"
    subnet_id = "${module.peered-vpcs.us-east-private-subnet}"
    
    tags = {
        Name = "kevin-temp-ws"
    }
}

resource "aws_security_group" "webserver-sg" {
    name = "webserver-sg"
    description = "webserver security group"
    vpc_id = "${module.peered-vpcs.vpc-us-east}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

module "nginx-cdn" {
    source  = "app.terraform.io/kevinspace/nginx-cdn/aws"
    version = "0.1.8"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    server_hostname = "${aws_instance.webserver.private_ip}"
    us-east = true
    us-west = true
    eu-west = true
    us-east-keypair = "kevin-sedemos"
    us-west-keypair = "kevin-sedemos-or"
    eu-west-keypair = "kevin-sedemos-ir"
    us-east-vpc = "${module.peered-vpcs.vpc-us-east}"
    us-east-subnet = "${module.peered-vpcs.us-east-public-subnet}"
    us-west-vpc = "${module.peered-vpcs.vpc-us-west}"
    us-west-subnet = "${module.peered-vpcs.us-west-public-subnet}"
    eu-west-vpc = "${module.peered-vpcs.vpc-eu-west}"
    eu-west-subnet = "${module.peered-vpcs.eu-west-public-subnet}"
}

resource "aws_route53_record" "privatemodules" {
    zone_id = "${data.aws_route53_zone.hashizone.zone_id}"
    name = "privatemodules.${data.aws_route53_zone.hashizone.name}"
    type = "A"
    ttl = "300"

    geolocation_routing_policy {
        continent = "NA"
        country = "*"
    }

    set_identifier = "geomodule"
    records = [
        "${module.nginx-cdn.us-east-ip}",
        "${module.nginx-cdn.us-west-ip}",
        "${module.nginx-cdn.eu-west-ip}"
    ]
}
