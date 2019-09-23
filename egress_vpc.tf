resource "aws_vpc" "dev_svc_egress_vpc" {
    provider = "aws.dev_svc"
    
    cidr_block = "10.0.0.1/20"
}

resource "aws_subnet" "dev_svc_egress_nat_subnet" {
    provider = "aws.dev_svc"

    vpc_id = "${aws_vpc.dev_svc_egress_vpc.id}"
    cidr_block = "10.0.0.1/22"
}

// Create Internet gateway
resource "aws_internet_gateway" "igw" {
  provider = "aws.dev_svc"

  vpc_id = "${aws_vpc.dev_shared_egress_vpc.id}"
}

// create EIP needed for NAT gateway
resource "aws_eip" "dev_svc_egress_nat_eip" {
    provider = "aws.dev_svc"

    vpc = true
    depends_on = ["aws_internet_gw.igw"]
}

// create NAT gateway
resource "aws_nat_gateway" "ngw" {
    provider = "aws.dev_svc"

    allocation_id = "${aws_eip.dev_svc_egress_nat_eip}"
    subnet_id     = "${aws_subnet.dev_svc_egress_nat_subnet.id}"

    depends_on = ["aws_internet_gw.igw"]
}

// route to internet through NAT
resource "aws_route" "dev_svc_egress_vpc_route" {
    provider = "aws.dev_svc"

    route_table_id = "${aws_vpc.dev_svc_egress_vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_internet_gateway.ngw.id}"
}

// attach TGW to subnet
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_svc_egress_vpc_tgw_attach" {
    provider = "aws.dev_svc"
    
    transit_gateway_id = "${aws_ec2_transit_gateway.dev_svc_inet_tgw.id}"
    subnet_ids = ["${aws_subnet.dev_svc_egress_nat_subnet.id}"]
    vpc_id = "${aws_vpc.dev_shared_egress_vpc.id}"
}

