
output "instance_id" {
  description = "MAUSAM EC2 instance ID"
  value       = aws_instance.mausam.id
}

output "public_ip" {
  description = "MAUSAM EC2 public IP"
  value       = aws_instance.mausam.public_ip
}

output "public_dns" {
  description = "MAUSAM EC2 public DNS"
  value       = aws_instance.mausam.public_dns
}

output "website_url" {
  description = "MAUSAM website URL"
  value       = "http://${aws_instance.mausam.public_ip}:5000"
}
