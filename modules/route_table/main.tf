resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    name = "private-route-table"
  }
}

resource "aws_route" "public_igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.igw_id
}

resource "aws_route" "private_igw" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.nat_gw_id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)
  
  subnet_id = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}