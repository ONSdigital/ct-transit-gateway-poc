resource "aws_vpc" "dev_vpc" {
    cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "dev_vpc_subnet" {
    vpc_id = "${aws_vpc.dev_vpc.id}"
    cidr_block = "172.16.0.0/20"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev_vpc_tgw_attach" {
  subnet_ids         = ["${aws_subnet.dev_vpc_subnet.id}"]
  transit_gateway_id = "${var.transit_gateway_id}"
  vpc_id             = "${aws_vpc.dev_vpc.id}"
}

resource "aws_route_table" "dev_vpc_route_table" {
    vpc_id = "${aws_vpc.dev_vpc.id}"
}

resource "aws_route" "dev_vpc_tgw_route" {
    route_table_id = "${aws_route_table.dev_vpc_route_table.id}"
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_id = "${var.transit_gateway_id}"
}

resource "aws_main_route_table_association" "dev_vpc_subnet_route_assoc" {
    route_table_id = "${aws_route_table.dev_vpc_route_table.id}"
    vpc_id = "${aws_vpc.dev_vpc.id}"
}