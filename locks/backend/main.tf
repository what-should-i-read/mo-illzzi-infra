locals {
  region = "ap-northeast-2"
}

provider "aws" {
  region = local.region
}

module "lock-state" {
  source              = "git::https://github.com/div-ops/terraform-s3-lock.git//lock"
  aws_region          = local.region
  s3_bucket_name      = "mo-illzzi-backend-state"
  dynamodb_table_name = "mo_illzzi_backend_lock"
}
