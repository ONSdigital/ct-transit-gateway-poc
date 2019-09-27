# Backend S3 + Dynamo DB for locking
terraform {
  backend "s3" {
    
    bucket         = "ct-transit-gateway-poc-dev-vpc"
    key            = "transit-gateway-poc/terraform.tfstate"
    region         = "eu-west-2" # NB: No var usage allowed in in backend setup
    dynamodb_table = "ct-transit-gateway-poc-dev-vpc"
    encrypt        = true
  }
}
