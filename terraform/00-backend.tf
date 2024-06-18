terraform {
  backend "s3" {
    bucket = "backend-bucket-nasa-potd-app-gk"
    key    = "state"
    region = "eu-west-2"
  }
}
