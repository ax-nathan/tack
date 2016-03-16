provider "aws" { region = "${ var.aws.region }" }

# variables
variable "aws" {
  default = {
    account-id = ""
    azs = ""
    key-name = ""
    region = ""
  }
}
variable "cidr" {
  default = {
    vpc = "10.0.0.0/16"
    allow-ssh = "0.0.0.0/0"
  }
}
variable "coreos-aws" {
  default = {
    ami = ""
    channel = ""
    type = ""
  }
}
variable "etcd-ips" { default = "10.0.0.10,10.0.0.11,10.0.0.12" }
variable "instance-type" {
  default = {
    bastion = "t2.nano"
    etcd = "t2.small"
    worker = "t2.medium"
  }
}
variable "internal-tld" { default = "k8s" }
variable "name" {}

# outputs
output "azs"          { value = "${ var.aws.azs }" }
output "bastion-ip"   { value = "${ module.bastion.ip }" }
output "subnet-ids"   { value = "${ module.vpc.subnet-ids }" }
output "external-elb" { value = "${ module.etcd.external-elb }" }
output "cluster-id"   { value = "${ module.k8s.cluster-id }" }
