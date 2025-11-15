variable "aws_region" {
   default = "us-east-1"
}
variable "cluster_name" {
   default = "eks-private-cluster"
}
variable "cluster_version" {
   default = "1.28"
}
variable "az_count" {
   default = 2
   description = "Number of AZs to create subnets for (2 or 3 recommended)"
}
variable "vpc_cidr" {
   default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
   type = list(string)
   default = ["10.10.0.0/24" ,"10.10.1.0/24","10.10.2.0/24"]
}
variable "private_subnet_cidrs" {
   type = list(string)
   default = ["10.10.10.0/24","10.10.11.0/24","10.10.12.0/24"]
}
variable "node_group_instance_types" {
   type = list(string)
   default = ["t3.medium"]
}
variable "node_group_desired" {
   type = number
   default = 2
}
variable "enable_private_cluster" {
   type = bool
   default = false
   description = "If true: set API server endpoint to private access only (control plane not internet-accessible)"
}
