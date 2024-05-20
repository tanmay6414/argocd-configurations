module "devk8s_vibrenthealth_com" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.devk8s_vibrenthealth_com
  }
  server      = "https://api.devk8s.vibrenthealth.com"
  name        = "devk8s.vibrenthealth.com"
  add_cluster = true
}

module "qak8s_vibrenthealth_com" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.qak8s_vibrenthealth_com
  }
  server      = "https://api.qak8s.vibrenthealth.com"
  name        = "qak8s.vibrenthealth.com"
  add_cluster = true
}


module "vrpk8s_vibrenthealth_com" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.vrpk8s_vibrenthealth_com
  }
  server = "https://api.vrpk8s.vibrenthealth.com"
  name = "vrpk8s.vibrenthealth.com"
  add_cluster = true
}

module "stgk8s_joinallofus_org" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.stgk8s_joinallofus_org
  }
  server = "https://api.stgk8s.joinallofus.org"
  name = "stgk8s.joinallofus.org"
  add_cluster = true
}

module "pmik8s_joinallofus_org" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.pmik8s_joinallofus_org
  }
  server = "https://api.pmik8s.joinallofus.org"
  name = "pmik8s.joinallofus.org"
  add_cluster = true
}


module "bldk8s_vibrenthealth_com" {
  source = "./module/"
  providers = {
    kubernetes = kubernetes.bldk8s_vibrenthealth_com
  }
  name        = "bldk8s.vibrenthealth.com"
  add_cluster = true
  eks = true
}
