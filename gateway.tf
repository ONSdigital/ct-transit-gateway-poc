// TGW instance
resource "aws_ec2_transit_gateway" "tgw" {
    provider = "aws.dev_svc"

    description = "Dev Services internet TGW"
}

resource "aws_ec2_transit_gateway_route_table" "dev_svc_tgw_route_table" {
    provider = "aws.dev_svc"

    transit_gateway_id = "${aws_ec2_transit_gateway.dev_svc_inet_tgw.id}"
}

// RAM resource share
resource "aws_ram_resource_share" "tgw_ram_share" {
    provider = "aws.dev_svc"
    
    allow_external_principals = true
}

// RAM principal details for share
resource "aws_ram_principal_association" "tgw_ram_share_principal" {
    provider = "aws.dev_svc"
    
    principal = "${var.team_account}"
    resource_share_arn = "${aws_ram_resource_share.tgw_ram_share.arn}"
}

// RAM resource details for share
resource "aws_ram_resource_association" "tgw_ram_share_resource" {
    provider = "aws.dev_svc"

    resource_arn = "${aws_ec2_transit_gateway.tgw.arn}"
    resource_share_arn = "${aws_ram_resource_share.tgw_ram_share.arn}"
}

