resource "aws_eip" "nat_eip" {
  
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = element(var.public_subnet_ids, 0)

  tags = {
    name = "nat-gateway"
  }
}