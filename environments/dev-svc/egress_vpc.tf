resource "aws_vpc" "dev_svc_egress_vpc" {
    cidr_block = "10.0.0.0/20"
}

resource "aws_subnet" "dev_svc_egress_nat_subnet" {
    vpc_id = "${aws_vpc.dev_svc_egress_vpc.id}"
    cidr_block = "10.0.0.0/22"
}

// Create Internet gateway
resource "aws_internet_gateway" "dev_svc_egress_igw" {
  vpc_id = "${aws_vpc.dev_svc_egress_vpc.id}"
}

// create EIP needed for NAT gateway
resource "aws_eip" "dev_svc_egress_nat_eip" {
    vpc = true
    depends_on = ["aws_internet_gateway.dev_svc_egress_igw"]
}

// create NAT gateway
resource "aws_nat_gateway" "dev_svc_natgw" {
    allocation_id = "${aws_eip.dev_svc_egress_nat_eip.id}"
    subnet_id     = "${aws_subnet.dev_svc_egress_nat_subnet.id}"

    depends_on = ["aws_internet_gateway.dev_svc_egress_igw"]
}

// route to internet through NAT
resource "aws_route" "dev_svc_egress_vpc_route" {
    route_table_id = "${aws_vpc.dev_svc_egress_vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev_svc_natgw.id}"
}

// attach TGW to subnet
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_svc_egress_vpc_tgw_attach" {
    transit_gateway_id = "${aws_ec2_transit_gateway.dev_svc_tgw.id}"
    subnet_ids = ["${aws_subnet.dev_svc_egress_nat_subnet.id}"]
    vpc_id = "${aws_vpc.dev_svc_egress_vpc.id}"
}