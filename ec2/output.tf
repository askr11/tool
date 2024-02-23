output "ips"{
value = "aws_instance.aws[*].public_ip
}
