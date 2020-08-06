resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.public_subnet_1_az
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.public_subnet_2_az
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-2-${var.env}"
    Environment = var.env
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "route-table-public-${var.env}"
    Environment = var.env
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
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
