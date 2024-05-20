module "kubeadm_cluster" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.kubeadm_cluster
  }
  server      = "https://xx.xx.xx.xx"
  name        = "kubeadm_cluster"
  add_cluster = true
}


module "eks_cluster" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.eks_cluster
  }
  name        = "eks_cluster"
  add_cluster = true
  eks = true
}
