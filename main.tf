# CONFIGURE AWS PROVIDER
provider "aws" {
  region = var.region-name
}

# VPC
resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true 
  enable_dns_support = true
  tags = {
    Name = "Prod-rock-VPC"
  }
}

# Public subnet 1
resource "aws_subnet" "Test-public-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.cidr-for-pub-1
  availability_zone = var.Pub-1-AZ

  tags = {
    Name = "Test-public-sub1"
  }
}

# Public subnet 2
resource "aws_subnet" "Test-public-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.cidr-for-pub-2
  availability_zone = var.Pub-2-AZ

  tags = {
    Name = "Test-public-sub2"
  }
}

# Private subnet 1
resource "aws_subnet" "Test-private-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.cidr-for-priv-1
  availability_zone = var.Priv-1-AZ
  tags = {
    Name = "Test-private-sub1"
  }
}

# Private subnet 2
resource "aws_subnet" "Test-private-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.cidr-for-priv-2
  availability_zone = var.Priv-2-AZ

  tags = {
    Name = "Test-private-sub2"
  }
}


# Public Route Table
resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  route = []

  tags = {
    Name = "Test-pub-route-table"
  }
}

# Private Route Table
resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-priv-route-table"
  }
}

# Route association public

resource "aws_route_table_association" "public-route-table-association-1" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

resource "aws_route_table_association" "public-route-table-association-2" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

# Route association private

resource "aws_route_table_association" "private-route-table-association-1" {
  subnet_id      = aws_subnet.Test-private-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

resource "aws_route_table_association" "private-route-table-association-2" {
  subnet_id      = aws_subnet.Test-private-sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}


# Internet gateway

resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }
}


# AWS Route

resource "aws_route" "Test-igw-association" {
  route_table_id            = aws_route_table.Test-pub-route-table.id
  gateway_id                = aws_internet_gateway.Test-igw.id
  destination_cidr_block    = var.internet-gateway-association
}

# ELASTIC IP
resource "aws_eip" "Test-EIP" {
  vpc                       = true
  associate_with_private_ip = var.elastic-ip
}


#NAT GATEWAY
  resource "aws_nat_gateway" "Test-Nat-gateway" {
  allocation_id = aws_eip.Test-EIP.id
  subnet_id     = aws_subnet.Test-public-sub1.id
 }

# NAT GATEWAY ASSOCIATION WITH PRIVATE ROUTE
resource "aws_route" "Test-Nat-association" {
  route_table_id         = aws_route_table.Test-priv-route-table.id
  nat_gateway_id         = aws_nat_gateway.Test-Nat-gateway.id
  destination_cidr_block = var.nat-gateway-destination-cidr-block
}

# Configure Sec Group
resource "aws_security_group" "Test-sec-group" {
  name        = "allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.Prod-rock-VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Test-sec-group"
  }
}

#EC2 SERVERS
resource "aws_instance" "Test-server1" {
  ami           = "ami-05a8c865b4de3b127" # eu-west-2
  instance_type = "t2.micro"
  key_name = "Michael kp"
  vpc_security_group_ids =[aws_security_group.Test-sec-group.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.Test-public-sub1.id
}

resource "aws_instance" "Test-server2" {
  ami           = "ami-05a8c865b4de3b127" # eu-west-2
  instance_type = "t2.micro"
  key_name = "Michael kp"
  vpc_security_group_ids =[aws_security_group.Test-sec-group.id]
  associate_public_ip_address = true
  subnet_id      = aws_subnet.Test-private-sub1.id
}