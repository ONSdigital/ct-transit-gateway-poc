resource "aws_vpc" "dev_vpc" {
    cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "dev_vpc_subnet" {
    vpc_id = "${aws_vpc.dev_vpc.id}"
    cidr_block = "172.16.0.0/20"
}

data "aws_ec2_transit_gateway" "dev_svc_tgw" {
    description = "Dev Services internet TGW"
}

# resource "aws_ec2_transit_gateway_vpc_attachment" "dev_svc_tgw_attach" {
#   subnet_ids         = ["${aws_subnet.dev_vpc_subnet.id}"]
#   transit_gateway_id = "${var.transit_gateway_id}"
#   vpc_id             = "${aws_vpc.dev_vpc.id}"
# }