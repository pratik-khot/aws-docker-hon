terraform {
  backend "s3" {
    bucket = "tfstatebucket-916393717813-us-east-1-an"
    key    = "docker-hon/dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  } 
}
 