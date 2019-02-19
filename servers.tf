resource "aws_instance" "bastion" {
    ami = "ami-0664a710233d7c148"
    instance_type = "t2.micro"
    subnet_id="${aws_subnet.public_subnet_for_bastion_host.id}"
    security_groups = ["${aws_security_group.allow-SSH.id}"]
    key_name = "terraform_test"   
    tags {
        Name = "bastion-host"
    }

}


resource "aws_instance" "host1" {
    ami = "ami-0664a710233d7c148"
    instance_type = "t2.micro"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.allow-SSH.id}"]
    key_name = "terraform_test" 
    tags {
        Name = "my-host1"
    }

}


