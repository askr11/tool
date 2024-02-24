output "ips"{
value = aws_instance.aws1[*].private_ip
}
