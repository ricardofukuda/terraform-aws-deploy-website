remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "fukuda-abc-terraform-state-shared"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "fukuda-abc-terraform-state-lock-table-shared"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::123456789:role/terragrunt"
  }

  default_tags {
    tags = {
      Environment = "shared"
      Owner = "Terraform"
    }
  }
}
EOF
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "${get_terragrunt_dir()}/region.hcl"))

  aws_region  = local.region_vars.locals.aws_region
}