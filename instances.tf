/*
#my bastion instance
resource "aws_instance" "bastion" {
    ami = "${var.amis}"
    instance_type = "t2.micro"
    subnet_id="${aws_subnet.public_subnet_BASTION.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}"    
    tags {
        Name = "bastion-host"
    }

}

# my hosts
resource "aws_instance" "k8s-m1" {
    ami = "${var.amis}"
    instance_type = "t2.medium"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}" 
    tags {
        Name = "k8s-m1"
    }

}

# my hosts
resource "aws_instance" "k8s-s1" {
    ami = "${var.amis}"
    instance_type = "${var.inst_type}"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}"
    tags {
        Name = "k8s-s1"
    }

}
# my hosts
resource "aws_instance" "k8s-s2" {
    ami = "${var.amis}"
    instance_type = "${var.inst_type}"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}"
    tags {
        Name = "k8s-s2"
    }

}
*/



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

/*
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
*/

# my hosts
resource "aws_instance" "k8s-m1" {
    ami = "${var.amis}"
    instance_type = "t2.medium"
    subnet_id="${aws_subnet.private_subnet_for_3hosts.id}"
    security_groups = ["${aws_security_group.SSH.id}"]
    key_name = "${var.keyname}"
    tags {
        Name = "k8s-m1"
    }
}

resource "aws_launch_configuration" "worker" {
  # Launch Configurations cannot be updated after creation with the AWS API.
  # In order to update a Launch Configuration, Terraform will destroy the
  # existing resource and create a replacement.
  #
  # We're only setting the name_prefix here,
  # Terraform will add a random string at the end to keep it unique.
  name_prefix = "k8s-"

  image_id                    = "${var.amis}"
  instance_type               = "${var.inst_type}"
  security_groups             = ["${aws_security_group.SSH.id}"]
  key_name                    = "${var.keyname}"
  # user_data                   = "${data.template_cloudinit_config.user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  # Force a redeployment when launch configuration changes.
  # This will reset the desired capacity if it was changed due to
  # autoscaling events.
  name = "${aws_launch_configuration.worker.name}-asg"

  min_size             = 2
  desired_capacity     = 2
  max_size             = 3
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.worker.name}"
  vpc_zone_identifier  = ["${aws_subnet.private_subnet_for_3hosts.id}"]
  force_delete         = true
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}
