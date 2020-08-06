resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.65.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.66.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-2-${var.env}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "nat-gateway-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public_2.id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "nat-gateway-2-${var.env}"
    Environment = var.env
  }
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "nat-gateway-eip-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_eip" "nat_gateway_2" {
  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "nat-gateway-eip-2-${var.env}"
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
