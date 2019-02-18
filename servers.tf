
resource "aws_instance" "bastion" {
    ami = "ami-0664a710233d7c148"
    instance_type = "t2.micro"
    subnet_id="${aws_subnet.public_subnet_for_bastion_host.id}"

    tags {
        Name = "bastion-host"
    }

}

