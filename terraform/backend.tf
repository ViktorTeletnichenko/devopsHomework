terraform {
  backend "s3" {
    bucket         = "victor-tf-state-854313414"
    key            = "lemp/homework/terraform.tfstate"
    region         = "eu-central-1"
    profile        = "myaws"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
