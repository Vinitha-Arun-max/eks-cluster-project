resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
}
resource "aws_subnet" "public" {
 count = var.az_count
 vpc_id = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
 map_public_ip_on_launch = true
}
resource "aws_subnet" "private" {
 count = var.az_count
 vpc_id = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
}
 data "aws_availability_zones" "available" {
   state = "available"
}

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main.id
 route {
  cidr_block ="0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
}
resource "aws_route_table_association" "public_assoc" {
 count = var.az_count
 subnet_id = aws_subnet.public[count.index].id
 route_table_id = aws_route_table.public_rt.id
}

#Elastic IPs for NTA gateways:

resource "aws_eip" "nat" {
 count = var.az_count
 domain = "vpc"
}

#NAT gateways

resource "aws_nat_gateway" "nat" {
 count = var.az_count
 allocation_id = aws_eip.nat[count.index].id
 subnet_id = aws_subnet.public[count.index].id
 depends_on = [aws_internet_gateway.igw]
}

# private route tables:

resource "aws_route_table" "private_rt" {
 count = var.az_count
 vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_assoc" {
 count = var.az_count
 subnet_id = aws_subnet.private[count.index].id
 route_table_id = aws_route_table.private_rt[count.index].id
}
