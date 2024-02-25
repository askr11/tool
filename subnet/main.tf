resource "aws_subnet" "public_subnet" {
  vpc_id            = var.vpcid
count          = var.len
  availability_zone = var.az[count.index]
  
  cidr_block        = var.pub_subnet-cidr[count.index]
  tags = {
    Name = var.naam[count.index]
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = var.vpcid
  count          = var.len
availability_zone = var.az[count.index]
  cidr_block        = var.pri_subnet-cidr[count.index]
  tags = {
    Name = var.prinaam[count.index]
  }
}
