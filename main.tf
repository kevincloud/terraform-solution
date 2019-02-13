provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

resource "aws_instance" "webserver" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]
    user_data = "${data.template_file.user_data.rendered}"
    
    tags = {
        Name = "kevin-temp-ws"
    }
}

resource "aws_security_group" "webserver-sg" {
    name = "webserver-sg"
    description = "webserver security group"
    vpc_id = "${data.aws_vpc.mainvpc.id}"

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

module "peered-vpcs" {
  source  = "app.terraform.io/kevinspace/peered-vpcs/aws"
  version = "1.0.1"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
}

module "nginx-cdn" {
    source  = "app.terraform.io/kevinspace/nginx-cdn/aws"
    version = "0.1.1"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    server_hostname = "${aws_instance.webserver.public_ip}"
    us-east = true
    us-west = true
    eu-west = true
    us-east-vpc = "${module.peered-vpcs.vpc-us-east}"
    us-east-subnet = "${module.peered-vpcs.us-east-public-subnet}"
    us-west-vpc = "${module.peered-vpcs.vpc-us-west}"
    us-west-subnet = "${module.peered-vpcs.us-west-public-subnet}"
    eu-west-vpc = "${module.peered-vpcs.vpc-eu-west}"
    eu-west-subnet = "${module.peered-vpcs.eu-west-public-subnet}"
}

/*
module "nginx-east" {
    source  = "app.terraform.io/kevinspace/nginx-east/aws"
    version = "1.0.3"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    server_hostname = "${aws_instance.webserver.public_ip}"
}

module "nginx-west" {
    source  = "app.terraform.io/kevinspace/nginx-west/aws"
    version = "1.0.3"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    server_hostname = "${aws_instance.webserver.public_ip}"
}
*/
