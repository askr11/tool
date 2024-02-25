output "ips"{
value = aws_instance.aws1[*].private_ip
}
output "bips"{
value = aws_instance.aws[*].private_ip
}
