variable "region" {
  default = "ap-northeast-2"
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "mo-illzzi-backend-state"
    key    = "mo-illzzi-backend-terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "mo_illzzi_backend_lock"
    encrypt        = true
  }
}

module "ec2-key-pair" {
  source   = "git::https://github.com/div-ops/terraform-divops-modules.git//ec2/key-pair"
  key_name = "mo-illzzi-backend"
}

module "security-group" {
  source              = "git::https://github.com/div-ops/terraform-divops-modules.git//config/security-group"
  security_group_name = "mo-illzzi-backend-security-group"
  service_port_list   = [22]
}

resource "aws_instance" "web" {
  ami                    = "ami-0cbec04a61be382d9" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = module.ec2-key-pair.generated_key_key_name
  vpc_security_group_ids = [module.security-group.security_id]

  tags = {
    Name = "mo.illzzi.backend"
  }
}
