variable region {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "key name to use for creation of ec2 instances"
  type = string
  default = "my-kp"
}