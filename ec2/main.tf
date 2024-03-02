 resource "aws_instance" "aws" {
    ami           = var.image-id
    count= var.len
    instance_type = "t2.micro"
    key_name = var.public_keypair
    vpc_security_group_ids= var.sg
    subnet_id=var.publ_subnet[count.index]
    associate_public_ip_address = true
    tags = {
    Name = "bastion[count.index]"
  }
 /*provisioner "file" {
    source      = "/var/lib/jenkins/workspace/tool/keyins.pem"  # Update with the path to your local PEM key file
    destination = "/home/ubuntu/keyins.pem"
  }
  provisioner "local-exec" {
    command = "chmod 600 /home/ubuntu/keyins.pem"
  }*/
  }
   resource "aws_instance" "aws1" {
    ami           = var.image-id
    count= var.len
    instance_type = "t2.micro"
    vpc_security_group_ids= var.private_sg
    key_name = var.public_keypair
    subnet_id=var.priv_subnet[count.index]
    associate_public_ip_address = false
    tags = {
    Name = "private$[count.index]"
  }
  }
