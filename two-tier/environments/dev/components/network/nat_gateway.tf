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

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.main, aws_subnet.public_1]

  tags = {
    Name        = "nat-gateway-1-${var.env}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public_2.id
  depends_on    = [aws_internet_gateway.main, aws_subnet.public_2]

  tags = {
    Name        = "nat-gateway-2-${var.env}"
    Environment = var.env
  }
}
