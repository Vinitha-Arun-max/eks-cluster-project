module "eks" {
 source = "terraform-aws-modules/eks/aws"
 version ="~>19.16"
 cluster_name = var.cluster_name
 cluster_version = var.cluster_version
 subnet_ids = aws_subnet.private[*].id
 vpc_id = aws_vpc.main.id

#control plane endpoint access

cluster_endpoint_private_access = true
cluster_endpoint_public_access = var.enable_private_cluster ? false:true

#node groups

eks_managed_node_groups = {
 ng_general = {
  desired_size = var.node_group_desired
  max_size = var.node_group_desired + 1
  min_size = 1
  instance_types = var.node_group_instance_types
  disk_size = 20
  subnet_ids = aws_subnet.private[*].id
}
} 

}
