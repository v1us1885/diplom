output "network_id" {
  value = yandex_vpc_network.k8s_network.id
}

output "subnet_a_id" {
  value = yandex_vpc_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = yandex_vpc_subnet.subnet_b.id
}

output "subnet_d_id" {
  value = yandex_vpc_subnet.subnet_d.id
}
