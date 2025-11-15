provider "aws" {
 region = var.region
}

resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
}
resource "aws_subnet" "subneta" {
 vpc_id = aws_vpc.main.id
 cidr_block = var.subnet_cidr
 map_public_ip_on_launch = true
}

resource "aws_route_table" "rt" {
 vpc_id = aws_vpc.main.id
}
resource "aws_route_table_association" "subneta_association" {
 route_table_id = aws_route_table.rt.id
 subnet_id = aws_subnet.subneta.id
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_access" {
 route_table_id = aws_route_table.rt.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main.id
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
}
resource "aws_route_table_association" "public_association" {
 subnet_id = aws_subnet.subneta.id
 route_table_id = aws_route_table.rt.id
}
resource "aws_key_pair" "jenkins_key" {
 key_name = var.key_name
 public_key = file(var.ssh_pub_key_path)
}
resource "aws_security_group" "jenkins_sg" {
 name = "jenkins-sg"
 vpc_id = aws_vpc.main.id
 description = "Allow SSH and Jenkins ports"
 ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.admin_cidr]
}
 ingress {
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = [var.admin_cidr]
}
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_instance" "jenkins_server" {
 ami = var.ami_id
 instance_type = var.instance_type
 key_name = aws_key_pair.jenkins_key.key_name
 vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
 subnet_id = aws_subnet.subneta.id
 user_data = file("${path.module}/user_data.sh")
}

output "jenkins_public_ip" {
 value = aws_instance.jenkins_server.public_ip
}


