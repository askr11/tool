output "private_route_table"{
value=aws_route_table.private.id
}
output "public_route_table"{
value=aws_route_table.public.id
}
