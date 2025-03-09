resource "yandex_kubernetes_node_group" "node-group" {
  cluster_id  = yandex_kubernetes_cluster.k8s_cluster.id
  name        = "node-group"
  description = "Worker-ноды для MKS"
  version     = "1.28"

  scale_policy {
    fixed_scale {
      size = 3 
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
    location {
      zone = "ru-central1-b"
    }
    location {
      zone = "ru-central1-d"
    }
  }

  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 4
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    network_interface {
      subnet_ids = local.subnet_ids
      nat        = true
    }

    container_runtime {
      type = "containerd"
    }

  }

  depends_on = [yandex_kubernetes_cluster.k8s_cluster]
}
