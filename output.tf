output "instance_public_ip" {
    description = "The public IP address of the EC2 instance."
    value       = aws_instance.hon-practise-instance.public_ip
}

output "aws_ec2_instance_connect_endpoint" {
    description = "The EC2 Instance Connect Endpoint for the instance."
    value       = aws_ec2_instance_connect_endpoint.hon-practise-ec2-instance-connect-endpoint.dns_name
}


output "key_fingerprint" {
  value = data.aws_key_pair.example.fingerprint
}

output "key_name" {
  value = data.aws_key_pair.example.key_name
}

output "key_id" {
  value = data.aws_key_pair.example.id
}