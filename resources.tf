#main vpc module

resource "aws_vpc" "t_project_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "terraform_project_vpc"
  }
}

#public subnet for bastion
resource "aws_subnet" "public_subnet_for_bastion_host" {
  cidr_block = "${cidrsubnet(aws_vpc.t_project_vpc.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.t_project_vpc.id}"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true #so it could use internet
  tags {
    Name = "public_subnet_for_bastion_host"
  }
}

#private subnet for my hosts
resource "aws_subnet" "private_subnet_for_3hosts" {
  cidr_block = "${cidrsubnet(aws_vpc.t_project_vpc.cidr_block, 2, 2)}"
  vpc_id = "${aws_vpc.t_project_vpc.id}"
  availability_zone = "eu-west-2a"
  tags {
    Name = "private_subnet_for_3_hosts"
  }
}



#we all need internet, this is how we get it
resource "aws_internet_gateway" "internet_for_my_VPC" {
  vpc_id = "${aws_vpc.t_project_vpc.id}"

  tags = {
    Name = "gateway_for_t_project_vpc"
  }
}


# route table, that allow transfering data to internet
resource "aws_route_table" "for_public_subnet" {
  vpc_id = "${aws_vpc.t_project_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0" #link
    gateway_id = "${aws_internet_gateway.internet_for_my_VPC.id}"
  }
}


resource "aws_route_table_association" "for_public_subnet" {
    subnet_id = "${aws_subnet.public_subnet_for_bastion_host.id}"
    route_table_id = "${aws_route_table.for_public_subnet.id}"
}



resource "aws_eip" "terraformtraining-nat" {
vpc      = true
}
resource "aws_nat_gateway" "terraformtraining-nat-gw" {
allocation_id = "${aws_eip.terraformtraining-nat.id}"
subnet_id = "${aws_subnet.public_subnet_for_bastion_host.id}"
depends_on = ["aws_internet_gateway.internet_for_my_VPC"]
}

# Terraform Training VPC for NAT
resource "aws_route_table" "terraformtraining-private" {
    vpc_id = "${aws_vpc.t_project_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.terraformtraining-nat-gw.id}"
    }

    tags {
        Name = "terraformtraining-private-1"
    }
}
# Terraform Training private routes
resource "aws_route_table_association" "terraformtraining-private-1-a" {
    subnet_id = "${aws_subnet.private_subnet_for_3hosts.id}"
    route_table_id = "${aws_route_table.terraformtraining-private.id}"
}


# # elastic ip
# resource "aws_eip" "nat_gw_eip" {
#   vpc = true
# }




# #NAT
# resource "aws_nat_gateway" "gw" {
#   allocation_id = "${aws_eip.nat_gw_eip.id}"
#   subnet_id     = "${aws_subnet.public_subnet_for_bastion_host.id}"
# }

# #route table for nat, managing internet connection
# resource "aws_route_table" "my_vpc_route_tb" {
#     vpc_id = "${aws_vpc.t_project_vpc.id}"

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = "${aws_eip.nat_gw_eip.id}"
#     }

#     tags {
#         Name = "Main Route Table for nat bastion subnet"
#     }
# }

# resource "aws_route_table_association" "my_vpc_route_tb" {
#     subnet_id = "${aws_subnet.public_subnet_for_bastion_host.id}"
#     route_table_id = "${aws_route_table.my_vpc_route_tb.id}"
# }
