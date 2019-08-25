##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "ps-tf-private-key-pair"
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
  private_ip    = "10.0.0.12"
  subnet_id     = "${aws_subnet.us-east-1a-public.id}"
  vpc_security_group_ids = ["${aws_security_group.ps-tf-sec-grp.id}"]

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
  vpc_id                  = "${aws_vpc.ps-tf-vpc.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  depends_on              = ["aws_internet_gateway.ps-tf-gw"]
}

resource "aws_vpc" "ps-tf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "ps-tf-gw" {
  vpc_id = "${aws_vpc.ps-tf-vpc.id}"

  tags = {
    Name = "tf-gw"
  }
}

resource "aws_route_table" "ps-tf-rt" {
  vpc_id = "${aws_vpc.ps-tf-vpc.id}"

//  route {
//    cidr_block = "10.0.0.0/16"
//    gateway_id = local
//  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ps-tf-gw.id}"
  }

  tags = {
    Name = "tf-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.us-east-1a-public.id}"
  route_table_id = "${aws_route_table.ps-tf-rt.id}"
}

resource "aws_eip" "ps-tf-elastic-ip" {
  vpc        = true

  instance   = "${aws_instance.nginx.id}"
  associate_with_private_ip = "10.0.0.12"
  depends_on = ["aws_internet_gateway.ps-tf-gw"]
}

resource "aws_security_group" "ps-tf-sec-grp" {
  name        = "ps-tf-sec-grp"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_vpc.ps-tf-vpc.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    #prefix_list_ids = ["pl-12c4e678"]
  }
}

resource "aws_network_interface" "ps-tf-net-if" {
  subnet_id       = "${aws_subnet.us-east-1a-public.id}"
  #private_ips     = ["10.0.0.50"]
  security_groups = ["${aws_security_group.ps-tf-sec-grp.id}"]

  attachment {
    instance     = "${aws_instance.nginx.id}"
    device_index = 1
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
    value = "${aws_instance.nginx.public_dns}"
}
