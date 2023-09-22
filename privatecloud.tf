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
resource "aws_subnet" "cicd_subnet" {
  cidr_block = "10.1.1.0/24"
  vpc_id     = aws_vpc.cicd_vpc.id
  availability_zone = var.zone
  map_public_ip_on_launch = true

  tags = {
    Name = "cicd_subnet"
  }
}

resource "aws_subnet" "cicd_subnet_2" {
   cidr_block = "10.1.2.0/24"
   vpc_id     = aws_vpc.cicd_vpc.id
   availability_zone = var.zone2
   map_public_ip_on_launch = true

   tags = {
     Name = "cicd_subnet_2"
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
resource "aws_route_table_association" "cicd_rta" {
  subnet_id      = aws_subnet.cicd_subnet.id
  route_table_id = aws_route_table.cicd_pub_rt.id
}

/* Future project
resource "aws_route_table_association" "cicd_rta_2" {
   subnet_id      = aws_subnet.cicd_subnet_2.id
   route_table_id = aws_route_table.cicd_pub_rt.id
 }
*/
