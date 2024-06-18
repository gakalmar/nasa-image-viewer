provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "backend-bucket-nasa-potd-app-gk"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true
}

output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}
