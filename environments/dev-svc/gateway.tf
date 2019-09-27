// TGW instance
resource "aws_ec2_transit_gateway" "dev_svc_tgw" {
    description = "Dev Services internet TGW"
}

resource "aws_ec2_transit_gateway_route_table" "dev_svc_tgw_route_table" {
    transit_gateway_id = "${aws_ec2_transit_gateway.dev_svc_tgw.id}"
}

// RAM resource share
resource "aws_ram_resource_share" "tgw_ram_share" {
    name = "TGW share with survey-dev"
    allow_external_principals = true
}

// RAM principal details for share
resource "aws_ram_principal_association" "tgw_ram_share_principal" {
    principal = "${var.team_account}"
    resource_share_arn = "${aws_ram_resource_share.tgw_ram_share.arn}"
}

// RAM resource details for share
resource "aws_ram_resource_association" "tgw_ram_share_resource" {
    resource_arn = "${aws_ec2_transit_gateway.dev_svc_tgw.arn}"
    resource_share_arn = "${aws_ram_resource_share.tgw_ram_share.arn}"
}