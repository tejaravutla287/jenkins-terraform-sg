provider "aws" {
  region = "us-east-1"
}
 
# 2. Create the EKS Cluster (The "Brain")
resource "aws_eks_cluster" "poc" {
  name     = "poc-cluster"
  role_arn = "arn:aws:iam::567017110325:role/eks-cluster-role-poc-2"
 
  vpc_config {
    # These two subnets MUST belong to the same VPC

    subnet_ids = [
      "subnet-0d2c14c66f6530651", # us-east-1a
      "subnet-03dd3ff00040da7ff", # us-east-1b
      "subnet-04816d32cf91f4879"  # us-east-1c (optional but recommended)
    ]

  }
}
 
# 3. Create the Node Group (The "Body" / Servers)
resource "aws_eks_node_group" "poc_nodes" {
  cluster_name    = aws_eks_cluster.poc.name
  node_group_name = "poc-node-group"
  node_role_arn   = "arn:aws:iam::567017110325:role/eks-node-role-poc"

    subnet_ids = [
      "subnet-0d2c14c66f6530651", # us-east-1a
      "subnet-03dd3ff00040da7ff", # us-east-1b
      "subnet-04816d32cf91f4879"  # us-east-1c (optional but recommended)
    ]

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
