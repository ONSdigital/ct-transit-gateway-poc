# Backend S3 + Dynamo DB for locking
terraform {
  backend "s3" {
    provider = "aws.dev_svc"

    bucket         = "ct-transit-gateway-poc"
    key            = "transit-gateway-poc/terraform.tfstate"
    region         = "eu-west-2" # NB: No var usage allowed in in backend setup
    dynamodb_table = "es-terraform-lock-state"
    encrypt        = true
  }
}
