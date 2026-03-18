terraform {
  backend "s3" {
    bucket = "tfstatebucket-900335273390-us-east-1-an"
    key    = "docker-hon/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
