variable "tf_version" {
    description = "AWS provider version"
    default = "~> 2.27.0"
}

variable "region" {
    description = "AWS region"
    default = "eu-west-2"
}

variable "team_account" {
    description = "Account ID for non-service dev account (survey-dev)"
}


