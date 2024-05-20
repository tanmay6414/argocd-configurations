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
    bucket                  = "vignetmanagement-terraform-state"
    key                     = "argocd/argocd-project"
    region                  = "us-east-1"
    encrypt                 = true
    shared_credentials_file = "/vault/secrets/vault-s3"
    profile                 = "aws_management_cli"
  }
}

# those credential must able to access eks admin role
provider "aws" {
  region = "us-east-1"
  access_key =  ""
  secret_key = ""
  token = ""
}

provider "argocd" {
  server_addr = "argocd.ssk8s.vibrenthealth.com"
  username    = ""
  password    = ""
  grpc_web    = true
  insecure    = true
}


provider "kubernetes" {
  alias          = "devk8s_vibrenthealth_com"
  config_path    = "~/.kube/config"
  config_context = "" #"user-devk8s.vibrenthealth.com"
}

provider "kubernetes" {
  alias = "qak8s_vibrenthealth_com"
  config_path    = "~/.kube/config"
  config_context = "" #"user-qak8s.vibrenthealth.com"
}

provider "kubernetes" {
  alias = "vrpk8s_vibrenthealth_com"
  config_path    = "~/.kube/config"
  config_context = "" #"user-vrpk8s.vibrenthealth.com"
}
provider "kubernetes" {
  alias = "stgk8s_joinallofus_org"
  config_path    = "~/.kube/config"
  config_context = "" #"user-stgk8s.joinallofus.org"
}
provider "kubernetes" {
  alias = "pmik8s_joinallofus_org"
  config_path    = "~/.kube/config"
  config_context = "" #"user-pmik8s.joinallofus.org"
}

provider "kubernetes" {
  alias                  = "bldk8s_vibrenthealth_com"
  host                   = data.aws_eks_cluster.cluster["bldk8s_vibrenthealth_com"].endpoint
  token                  = data.aws_eks_cluster_auth.cluster["bldk8s_vibrenthealth_com"].token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster["bldk8s_vibrenthealth_com"].certificate_authority.0.data)
}
data "aws_eks_cluster" "cluster" {
  for_each = toset(["bldk8s_vibrenthealth_com"])
  name  = each.value
}
data "aws_eks_cluster_auth" "cluster" {
  for_each = toset(["bldk8s_vibrenthealth_com"])
  name  = each.value
}