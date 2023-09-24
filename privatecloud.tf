provider "aws" {
  region = var.region 
}

# VPC info
resource "aws_vpc" "cicd_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "cicd_vpc"
  }
}

# Subnet info
resource "aws_subnet" "cicd_subnet_a" {
  cidr_block = "10.1.1.0/24"
  vpc_id     = aws_vpc.cicd_vpc.id
  availability_zone = us-west-2a
  map_public_ip_on_launch = true

  tags = {
    Name = "cicd_subnet_a"
  }
}

resource "aws_subnet" "cicd_subnet_b" {
   cidr_block = "10.1.2.0/24"
   vpc_id     = aws_vpc.cicd_vpc.id
   availability_zone = us-west-2b
   map_public_ip_on_launch = true

   tags = {
     Name = "cicd_subnet_b"
   }
}

resource "aws_subnet" "cicd_subnet_c" {
   cidr_block = "10.1.3.0/24"
   vpc_id     = aws_vpc.cicd_vpc.id
   availability_zone = us-west-2c
   map_public_ip_on_launch = true

   tags = {
     Name = "cicd_subnet_c"
   }
}

# Internet Gateway info
resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id

  tags = {
    Name = "cicd_igw"
  }
}

# Route table info
resource "aws_route_table" "cicd_pub_rt" {
  vpc_id = aws_vpc.cicd_vpc.id

  tags = {
    Name = "cicd_pub_rt"
  }
}

# Associate public route table with internet gateway
resource "aws_route" "cicd_route" {
  route_table_id = aws_route_table.cicd_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.cicd_igw.id
}

# Associate route table with subnets
resource "aws_route_table_association" "cicd_rta_a" {
  subnet_id      = aws_subnet.cicd_subnet_a.id
  route_table_id = aws_route_table.cicd_pub_rt.id
}

resource "aws_route_table_association" "cicd_rta_b" {
   subnet_id      = aws_subnet.cicd_subnet_b.id
   route_table_id = aws_route_table.cicd_pub_rt.id
 }

resource "aws_route_table_association" "cicd_rta_c" {
   subnet_id      = aws_subnet.cicd_subnet_c.id
   route_table_id = aws_route_table.cicd_pub_rt.id
 }
