data "aws_availability_zones" "zones" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"

  tags {
    Name = "${format("%s", var.name)}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.private_subnets)}"

  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.zones.names, count.index)}"

  tags {
    Name = "${format("%s Private %d", var.name, count.index + 1)}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.public_subnets)}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(var.public_subnets, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.zones.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${format("%s Public %d", var.name, count.index + 1)}"
  }
}
