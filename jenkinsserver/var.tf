variable "region" {
 type = string
 description = "Enter the region that you want to deploy"
}

variable "vpc_cidr" {
 default = "10.0.0.0/16"
}

variable "subnet_cidr" {
 default = "10.0.1.0/24"
}
variable "ami_id" {
 description = "Amazon linux 2 ID"
 type = string
}

variable "instance_type" {
 default = "t2.medium"
}

variable "key_name" {
 description = "SSH key name"
 type = string
}
variable "ssh_pub_key_path" {
 description = "path to your public key "
 type = string
}

variable "admin_cidr" {
 description = "Your IP address range for SSH and jenkins access"
 type = string
}

