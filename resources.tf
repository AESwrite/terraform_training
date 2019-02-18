resource "aws_vpc" "t_project_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "terraform_project_vpc"
  }
}

resource "aws_subnet" "public_subnet_for_bastion_host" {
  cidr_block = "${cidrsubnet(aws_vpc.t_project_vpc.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.t_project_vpc.id}"
  availability_zone = "eu-west-2a"
  tags {
    Name = "public_subnet_for_bastion_host"
  }

}

resource "aws_subnet" "public_subnet_2" {
  cidr_block = "${cidrsubnet(aws_vpc.t_project_vpc.cidr_block, 2, 2)}"
  vpc_id = "${aws_vpc.t_project_vpc.id}"
  availability_zone = "eu-west-2a"
  tags {
    Name = "public_subnet_2"
  }
}

resource "aws_security_group" "subnetsecurity" {
    vpc_id = "${aws_vpc.t_project_vpc.id}"
    ingress {
        cidr_blocks = ["${aws_vpc.t_project_vpc.cidr_block}"]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

}
