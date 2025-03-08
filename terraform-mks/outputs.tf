output "mks_cluster_id" {
  value = yandex_kubernetes_cluster.k8s_cluster.id
}

output "mks_master_external_ip" {
  value = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_address
}
