##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "PluralsightKeys"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "nginx" {
  ami           = "ami-c58c1dd3"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.us-east-1a-public.id}"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}

resource "aws_subnet" "us-east-1a-public" {
  vpc_id = "${aws_vpc.example.id}"
  cidr_block = "10.0.1.0/25"
  availability_zone = "us-east-1a"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
    value = "${aws_instance.nginx.public_dns}"
}
