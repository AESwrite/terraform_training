 resource "aws_security_group" "SSH" {
 name = "allow-SSH"
 vpc_id = "${aws_vpc.terraform_VPC.id}"
 ingress {
    cidr_blocks = [
      "${var.internet_cidr}"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["${var.internet_cidr}"]
 }
}
