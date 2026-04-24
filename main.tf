provider "aws" {
  region = "us-east-1"
}
 
# 2. Create the EKS Cluster (The "Brain")
resource "aws_eks_cluster" "poc" {
  name     = "poc-cluster"
  role_arn = "arn:aws:iam::567017110325:role/eks-cluster-role-poc-2"
 
  vpc_config {
    # These two subnets MUST belong to the same VPC
    subnet_ids = ["subnet-0160ded4c7fafd2fe", "subnet-03cd75537e88e3946"]
  }
}
 
# 3. Create the Node Group (The "Body" / Servers)
resource "aws_eks_node_group" "poc_nodes" {
  cluster_name    = aws_eks_cluster.poc.name
  node_group_name = "poc-node-group"
  node_role_arn   = "arn:aws:iam::567017110325:role/eks-node-role-poc"
  subnet_ids = ["subnet-0160ded4c7fafd2fe", "subnet-03cd75537e88e3946"]
 
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
 
  # High-performance instances for your app
  instance_types = ["c7i-flex.large"]
 
  # Ensures the cluster is fully active before starting nodes
  depends_on = [aws_eks_cluster.poc]
}
