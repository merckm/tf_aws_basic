provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-5652ce39"          # Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type
  instance_type = "t2.micro"

  tags {
    Name = "martins bastion"
  }
}
