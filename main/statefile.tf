terraform {
  backend "s3" {
    bucket = "github-terraform-bucket123"
    key    = "infra.tfstate"
    region = "us-east-1"
    profile = "default"
    dynamodb_table = "vegeta-terraform-remote-state-table"
  }
}