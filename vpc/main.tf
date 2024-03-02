
resource "aws_vpc" "batch24" {
  cidr_block=var.cidr
    tags = {
    Name = var.name
  }
  vpc_id="vpc-0e72133ab6ab16bd0"
}
