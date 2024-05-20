variable "server" {
  type = string
  default = "empty"
}

variable "name" {
  type = string
}
variable "add_cluster" {
  type = bool
}
variable "eks" {
  type    = bool
  default = false
}
variable "eks_role" {
  type    = string
  default = "arn:aws:iam::123456789:role/eks-admin"
}
