#VPC block
resource "aws_vpc" "terraform_VPC" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "terraform_vpc"
  }
}

#Public subnet for bastion
resource "aws_subnet" "public_subnet_BASTION" {
  cidr_block = "${var.public_subnet_cidr}"
  vpc_id = "${aws_vpc.terraform_VPC.id}"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true #so it could use internet
  tags {
    Name = "public_subnet_BASTION"
  }
}

#private subnet for my hosts
resource "aws_subnet" "private_subnet_for_3hosts" {
  cidr_block = "${var.private_subnet_cidr}"
  vpc_id = "${aws_vpc.terraform_VPC.id}"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = false
  tags {
    Name = "private_subnet_for_3_hosts"
  }
}



#we all need internet, this is how we get it
resource "aws_internet_gateway" "internet_for_my_VPC" {
  vpc_id = "${aws_vpc.terraform_VPC.id}"

  tags = {
    Name = "gateway_for_terraform_VPC"
  }
}


# route table, that allow transfering data to internet
resource "aws_route_table" "for_public_subnet" {
  vpc_id = "${aws_vpc.terraform_VPC.id}"

  route {
    cidr_block = "${var.internet_cidr}"
    gateway_id = "${aws_internet_gateway.internet_for_my_VPC.id}"
  }
}


resource "aws_route_table_association" "for_public_subnet" {
    subnet_id = "${aws_subnet.public_subnet_BASTION.id}"
    route_table_id = "${aws_route_table.for_public_subnet.id}"
}


#elastic ip configuring
resource "aws_eip" "my_NAT" {
vpc      = true
}

#creating NAT
resource "aws_nat_gateway" "my_NAT-gw" {
allocation_id = "${aws_eip.my_NAT.id}"
subnet_id = "${aws_subnet.public_subnet_BASTION.id}"
depends_on = ["aws_internet_gateway.internet_for_my_VPC"]
}

# Terraform Training VPC for NAT
resource "aws_route_table" "TF-private_route-table" {
    vpc_id = "${aws_vpc.terraform_VPC.id}"
    route {
        cidr_block = "${var.internet_cidr}"
        nat_gateway_id = "${aws_nat_gateway.my_NAT-gw.id}"
    }

    tags {
        Name = "TF-private_route-table-1"
    }
}
# Terraform Training private routes
resource "aws_route_table_association" "TF-private" {
    subnet_id = "${aws_subnet.private_subnet_for_3hosts.id}"
    route_table_id = "${aws_route_table.TF-private_route-table.id}"
}


