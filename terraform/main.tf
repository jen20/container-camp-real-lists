provider "aws" {
  region = "us-west-2"
}

variable "consul_ami" {
  type    = "string"
  default = "ami-297bbf49"
}

variable "key_name" {
  type    = "string"
  default = "buildstuffua"
}

variable "cidr_block" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = "list"
  default = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
}

variable "private_subnets" {
  type    = "list"
  default = ["10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19"]
}

module "vpc" {
  source = "./modules/vpc"

  name            = "Production"
  cidr            = "${var.cidr_block}"
  private_subnets = ["${var.private_subnets}"]
  public_subnets  = ["${var.public_subnets}"]
}

module "vpn" {
  source = "./modules/vpn"

  vpc_id        = "${module.vpc.vpc_id}"
  public_subnet = "${element(module.vpc.public_subnets, 0)}"
  key_name      = "${var.key_name}"
}

module "consul" {
  source = "./modules/consul"

  cluster_name = "Production"

  vpc_id              = "${module.vpc.vpc_id}"
  subnets             = ["${module.vpc.private_subnets}"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  key_name      = "${var.key_name}"
  ami           = "${var.consul_ami}"
  instance_type = "t2.micro"
}

output "vpn_ip" {
  value = "${module.vpn.vpn_ip}"
}

output "vpn_setup" {
  value = "ssh openvpnas@${module.vpn.vpn_ip}"
}

output "vpn_login" {
  value = "https://${module.vpn.vpn_ip}:943"
}

output "vpc_public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "vpc_private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_availability_zones" {
  value = ["${module.vpc.public_availability_zones}"]
}

output "private_availability_zones" {
  value = ["${module.vpc.private_availability_zones}"]
}
