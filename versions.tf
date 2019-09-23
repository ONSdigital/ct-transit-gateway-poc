terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  alias = "dev_svc"

  region  = "${var.region}"
  version = "${var.tf_version}"
}


