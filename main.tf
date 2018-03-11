provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-5652ce39"          # Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = "merck"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
            #!/bin/bash
            sudo yum -y install busybox
            echo "Hello World" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags {
    Name = "Basic Webserver"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
