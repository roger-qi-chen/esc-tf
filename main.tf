provider "aws" {
  region                  = var.aw_region
  shared_credentials_file = var.aws_credentials
  profile                 = var.profile

}

terraform {
  backend "s3" {
    bucket         = "aw-cheetah-tfstate"
    key            = "aw-cheetah-infra-deployment-tf/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "aw-infra-tfstate"
  }
}