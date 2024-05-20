terraform {
  required_providers {
    argocd = {
      source  = "mediwareinc/argocd"
      version = "2.2.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
  backend "s3" {
    bucket                  = "tanmay-statebucket"
    key                     = "argocd/argocd-project"
    region                  = "us-east-1"
    encrypt                 = true
    access_key              = "xxxxxxxxxxxxxxxxxxxx"
    secret_key              = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    token                   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    profile                 = "aws_management_cli"
  }
}

# those credential must able to access eks admin role
provider "aws" {
  region = "us-east-1"
  access_key =  "xxxxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

provider "argocd" {
  server_addr = "argocd.com"
  username    = "admin"
  password    = "xxxxxxx"
  grpc_web    = true
  insecure    = true
}


provider "kubernetes" {
  alias          = "kubeadm_cluster"
  config_path    = "~/.kube/config"
  config_context = "kubeadm_cluster"
}

provider "kubernetes" {
  alias                  = "eks_cluster"
  host                   = data.aws_eks_cluster.cluster["eks_cluster"].endpoint
  token                  = data.aws_eks_cluster_auth.cluster["eks_cluster"].token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster["eks_cluster"].certificate_authority.0.data)
}
data "aws_eks_cluster" "cluster" {
  for_each = toset(["eks_cluster"])
  name  = each.value
}
data "aws_eks_cluster_auth" "cluster" {
  for_each = toset(["eks_cluster"])
  name  = each.value
}
