resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1_cidr_block
  availability_zone       = var.private_subnet_1_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2_cidr_block
  availability_zone       = var.private_subnet_2_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-2-${var.env}"
    Environment = var.env
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "route-table-private-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "route-table-private-2-${var.env}"
    Environment = var.env
  }
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_2" {
  route_table_id         = aws_route_table.private_2.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_2.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}
