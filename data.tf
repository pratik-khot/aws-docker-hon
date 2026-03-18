data "aws_ami" "latest" {
    most_recent = true
    filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "aws_key_pair" "example" {
  key_name           = var.key_name
  region =  var.region
  include_public_key = true

}

