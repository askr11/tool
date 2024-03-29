
module "vpc2"{
  source= "./vpc"
  cidr= var.addr
name=var.nam 
}

module "subnet"{
  source= "./subnet"
  len=length(var.sdr)
  az=var.avail_zone
  vpcid=module.vpc2.vpc-id
  pub_subnet-cidr=var.sdr
  pri_subnet-cidr=var.pdr
  prinaam = var.priname
 naam=var.subnet_name
}

module "gateway" {
  source="./igw"
  id_vpc=module.vpc2.vpc-id
  igw_name=var.gateway_name
}

module "nat" {
  source="./nat"
  subnetid=module.subnet.subnet-id
  nat_gw="ninja-nat-01"
  n_gateway=[module.gateway.gw_id]
}
module "route_tables" {
  source                   = "./route"
  vpc_id                   = module.vpc2.vpc-id
  public_subnet_ids        = module.subnet.subnet-id
  private_subnet_ids       = module.subnet.prisubnet-id
  internet_gateway_id      = module.gateway.gw_id
  nat_id=module.nat.ngw
}
module "ec2"{
  source="./ec2"
  image-id=var.am
  len=2
  public_keypair=aws_key_pair.tf-key-pair.key_name
  publ_subnet = module.subnet.subnet-id
  priv_subnet=module.subnet.prisubnet-id
  sg=[aws_security_group.allow_all.id]
  private_sg = [aws_security_group.private_subnet_sg.id]
  depends_on = [aws_security_group.allow_all]
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "keyins"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "./keyins.pem"  # Provide the desired path and file name with .pem extension
}
resource "null_resource" "change_permissions" {
  provisioner "local-exec" {
    command = "chmod 600 ./keyins.pem"
  }
  depends_on = [local_file.tf-key]
}
resource "aws_security_group" "allow_all" {
  name        = "allow-all-traffic"
  description = "Allow all traffic"
  
  // VPC ID where you want to create the security group
  vpc_id = module.vpc2.vpc-id

  // Inbound rule allowing all traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.all
  }

 ingress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.jenkins_cidr_block
   

  }

  // Outbound rule allowing all traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.all
  }
}

resource "aws_security_group" "private_subnet_sg" {
  name        = "private-instance-traffic"
  description = "only ssh access"
  
  // VPC ID where you want to create the security group
  vpc_id = module.vpc2.vpc-id

  // Inbound rule allowing all traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.all
  }
 ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.jenkins_cidr_block
   

  }
  // Outbound rule allowing all traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.all
  }
}
resource "local_file" "hosts" {
  content = templatefile("inventory.tmpl",
    {
      ubuntu_hosts = module.ec2.ips
      bastion_hosts= module.ec2.bips
      bastion_user   = var.bastionuser
    }
  )
  filename = "./inventory.yml"
}

resource "aws_vpc_peering_connection" "peer_connection" {
  vpc_id      = var.vpc_jenkins_server
  peer_vpc_id = module.vpc2.vpc-id
  auto_accept = true
 
  tags = {
    Name = "peer-connection"
  }
}

# Associate the peering connection with a route table in VPC1
resource "aws_route" "route_to_jenkins" {
  route_table_id            = var.jenkins_route_table
  destination_cidr_block    = var.addr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

# Associate the peering connection with a route table in VPC2
resource "aws_route" "route_to_peer_vpc2" {
  route_table_id            = module.route_tables.private_route_table
  destination_cidr_block    = var.jenkins_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}


# Associate the peering connection with a route table in VPC2
resource "aws_route" "route_to_peer_vpc22" {
  route_table_id            = module.route_tables.public_route_table
  destination_cidr_block    = var.jenkins_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

