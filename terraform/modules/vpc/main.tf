variable "name" {
  type = "string"
}

variable "cidr" {
  type = "string"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_availability_zones" {
  value = ["${aws_subnet.private.*.availability_zone}"]
}

output "public_availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
