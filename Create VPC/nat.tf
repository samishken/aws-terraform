# nat gw
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.first-public-1.id
  depends_on    = [aws_internet_gateway.sam-igw]
}

# VPC setup for NAT
resource "aws_route_table" "mainpriavtert" {
  vpc_id = aws_vpc.samvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "sam-rt-private-1"
  }
}

# route associations private
resource "aws_route_table_association" "first-private-1-a" {
  subnet_id      = aws_subnet.first-private-1.id
  route_table_id = aws_route_table.mainpriavtert.id
}

resource "aws_route_table_association" "second-private-2-a" {
  subnet_id      = aws_subnet.second-private-2.id
  route_table_id = aws_route_table.mainpriavtert.id
}

resource "aws_route_table_association" "third-private-3-a" {
  subnet_id      = aws_subnet.third-private-3.id
  route_table_id = aws_route_table.mainpriavtert.id
}

