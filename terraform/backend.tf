terraform {
  backend "s3" {
    bucket       = "bluepeak-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}