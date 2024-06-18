terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-hw-app-gk-240617"
    key    = "state"
    region = "eu-west-2"
  }
}
