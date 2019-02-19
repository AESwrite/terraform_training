
#my bastion instance
resource "aws_instance" "bastion" {
    ami = "${var.amis}"
    instance_type = "${var.inst_type}"
    subnet_id="${aws_subnet.public_subnet_BASTION.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}"    
    tags {
        Name = "bastion-host"
    }

}

# my hosts
resource "aws_instance" "host1" {
    ami = "${var.amis}"
    instance_type = "${var.inst_type}"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}" 
    tags {
        Name = "my-host1"
    }

}


