# Internet VPC
# VPC, 6 subnets (3 public & 3 private), IGW, 3 route tables
# ClassicLink allows you to link EC2-Classic instances to a VPC in your account.
resource "aws_vpc" "samvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "MyVpc"
  }
}

# Subnets
       # Public public_ip = "true"
resource "aws_subnet" "first-public-1" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "second-public-2" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "main-public-2"
  }
}

resource "aws_subnet" "third-public-3" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "main-public-3"
  }
}

         #Private public_ip = "false"
resource "aws_subnet" "first-private-1" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "second-private-2" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "main-private-2"
  }
}

resource "aws_subnet" "third-private-3" {
  vpc_id                  = aws_vpc.samvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "main-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "sam-igw" {
  vpc_id = aws_vpc.samvpc.id

  tags = {
    Name = "MyIGW"
  }
}

# route tables
resource "aws_route_table" "mainroutetable" {
  vpc_id = aws_vpc.samvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sam-igw.id
  }

  tags = {
    Name = "sam-rt-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "first-public-1-a" {
  subnet_id      = aws_subnet.first-public-1.id
  route_table_id = aws_route_table.mainroutetable.id
}

resource "aws_route_table_association" "second-public-2-a" {
  subnet_id      = aws_subnet.second-public-2.id
  route_table_id = aws_route_table.mainroutetable.id
}

resource "aws_route_table_association" "third-public-3-a" {
  subnet_id      = aws_subnet.third-public-3.id
  route_table_id = aws_route_table.mainroutetable.id
}

