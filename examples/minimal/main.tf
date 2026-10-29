terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "git::https://github.com/Olensys/terraform-aws-vpc.git?ref=v1.0.4"

  name = "example"
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }

  cidr             = "10.0.0.0/16"
  nat              = "none"
  enable_flow_logs = true
}

module "this" {
  source = "../../"

  name = "example"
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }

  vpc_id            = module.vpc.id
  route_table_id    = module.vpc.private_route_table_ids[0]
  cidr_block        = "10.0.200.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}
