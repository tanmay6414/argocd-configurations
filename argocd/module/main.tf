terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
    argocd = {
      source  = "mediwareinc/argocd"
      version = "2.2.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}


# Create the service account, cluster role + binding, which ArgoCD expects to be present in the targeted cluster
resource "kubernetes_service_account" "argocd_manager" {
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "argocd_manager" {
  depends_on = [ kubernetes_service_account.argocd_manager ]
  metadata {
    name = "argocd-manager-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "argocd_manager" {
  depends_on = [ kubernetes_cluster_role.argocd_manager ]
  metadata {
    name = "argocd-manager-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_manager.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_manager.metadata.0.name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
  }
}


data "kubernetes_secret" "argocd_manager" {
  depends_on = [ kubernetes_service_account.argocd_manager ]
  metadata {
    name      = kubernetes_service_account.argocd_manager.default_secret_name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
  }
  binary_data = {
    "ca.crt" = ""
    "token"  = ""
  }
}

resource "argocd_cluster" "kubernetes" {
  count      = var.add_cluster == true && var.eks != true ? 1 : 0
  depends_on = [data.kubernetes_secret.argocd_manager]
  server     = var.server
  name       = var.name
  config {
    bearer_token = base64decode(data.kubernetes_secret.argocd_manager.binary_data["token"])
    tls_client_config {
      ca_data = base64decode(data.kubernetes_secret.argocd_manager.binary_data["ca.crt"])
    }
  }
}



data "aws_eks_cluster" "cluster" {
  count = var.eks == true ? 1 : 0
  name  = replace(var.name, ".", "_")
}

resource "argocd_cluster" "eks" {
  count  = var.eks == true && var.add_cluster == true ? 1 : 0
  depends_on = [data.kubernetes_secret.argocd_manager]
  server = data.aws_eks_cluster.cluster[0].endpoint
  name   = var.name
  config {
    aws_auth_config {
      cluster_name = replace(var.name, ".", "_")
      role_arn     = var.eks_role
    }
    tls_client_config {
      ca_data = base64decode(data.aws_eks_cluster.cluster["0"].certificate_authority[0].data)
    }
  }
}