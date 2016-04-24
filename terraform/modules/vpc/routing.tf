resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${format("%s Gateway", var.name)}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${format("%s Private", var.name)}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc.id}"
  }

  tags {
    Name = "${format("%s Public", var.name)}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "nat_routes" {
  count                  = "${length(var.private_subnets)}"
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
}

resource "aws_eip" "nat_eip" {
  count = "${length(var.private_subnets)}"
  vpc   = true
}

resource "aws_nat_gateway" "private" {
  count = "${length(var.private_subnets)}"

  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}
