resource "aws_eks_cluster" "eks" {
  name     = "nasa-potd-eks-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids         = aws_subnet.eks_subnet[*].id
    security_group_ids = [aws_security_group.eks_sg.id]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nasa-potd-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn

  # Use a string comparison to filter for private subnets
  subnet_ids      = [for s in aws_subnet.eks_subnet : s.id if can(regex("private", s.tags["Name"]))]

  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.eks
  ]
}