resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks_vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  count = 2
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.eks_subnet[count.index].id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  count = 2
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route" "private_nat" {
  count                  = 2
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.eks_subnet[count.index + 2].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_subnet" "eks_subnet" {
  count = 4

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = count.index < 2 ? "10.0.${count.index}.0/24" : "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index % 2]
  map_public_ip_on_launch = count.index < 2 ? true : false

  tags = {
    Name = "eks_subnet_${count.index < 2 ? "public" : "private"}_${count.index % 2}"
    "kubernetes.io/cluster/nasa-potd-eks-cluster" = "owned"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.eks_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "eks_sg" {
  name   = "eks_sg"
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}