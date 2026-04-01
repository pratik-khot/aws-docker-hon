terraform {
  backend "s3" {
    bucket = "tfstatebucket-690509489991-us-east-1-an"
    key    = "docker-hon/dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  } 
}
 