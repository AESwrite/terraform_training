
resource "aws_instance" "bastion" {
    ami = "ami-0664a710233d7c148"
    instance_type = "t2.micro"

    tags {
        Name = "bastion-host"
    }

}

