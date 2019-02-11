provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

resource "aws_instance" "webserver" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]
    key_name = "kevin-sedemos"
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

module "nginx-east" {
    source  = "app.terraform.io/kevinspace/nginx-east/aws"
    version = "1.0.2"

    server_hostname = "${aws_instance.webserver.public_ip}"
}

module "nginx-west" {
    source  = "app.terraform.io/kevinspace/nginx-west/aws"
    version = "1.0.1"

    server_hostname = "${aws_instance.webserver.public_ip}"
}
