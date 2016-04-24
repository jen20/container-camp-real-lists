variable "vpc_id" {
  type = "string"
}

variable "public_subnet" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "ami" {
  type    = "string"
  default = "ami-a1b847c1"
}

output "vpn_ip" {
  value = "${aws_instance.openvpn.public_ip}"
}
