data "aws_vpc" "stage" {
  filter {
    name   = "tag:Name"
    values = ["vpc-stage"]
  }
}

data "aws_vpc" "dev" {
  filter {
    name   = "tag:Name"
    values = ["vpc-dev"]
  }
}
