output "frontend" {
  value       = aws_instance.frontend.public_ip
  description = "The public IP of the frontend"
}

output "monitor" {
  value       = aws_instance.monitor.public_ip
  description = "The public IP of the monitor"
}

output "add_server" {
  value       = aws_instance.servers[0].private_ip
  description = "The private IP of the add server"
}

output "sub_server" {
  value       = aws_instance.servers[1].private_ip
  description = "The private IP of the sub server"
}

output "mul_server" {
  value       = aws_instance.servers[2].private_ip
  description = "The private IP of the mul server"
}

output "div_server" {
  value       = aws_instance.servers[3].private_ip
  description = "The private IP of the div server"
}
