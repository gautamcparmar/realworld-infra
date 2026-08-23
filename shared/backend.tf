terraform {
  backend "s3" {
    bucket       = "realworld-tf-state-217478635962-ap-south-1-an"
    key          = "shared/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
    profile      = "default"
  }
}
