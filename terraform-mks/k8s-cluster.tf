resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name        = "mks-cluster"
  description = "Managed Kubernetes cluster in Yandex.Cloud"
  network_id  = data.terraform_remote_state.network.outputs.network_id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = data.terraform_remote_state.network.outputs.subnet_a_id
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = data.terraform_remote_state.network.outputs.subnet_b_id
      }

      location {
        zone      = "ru-central1-d"
        subnet_id = data.terraform_remote_state.network.outputs.subnet_d_id
      }
    }

    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.terraform-k8s.id
  node_service_account_id = yandex_iam_service_account.terraform-k8s.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.load-balancer-admin,
    yandex_resourcemanager_folder_iam_member.compute_editor,
    yandex_resourcemanager_folder_iam_member.k8s-editor,
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
  ]
  release_channel = "STABLE"
}

resource "yandex_iam_service_account" "terraform-k8s" {
  name        = "terraform-k8s-account"
  description = "K8S zonal service account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id = var.yc_folder_id
  role      = "k8s.editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
  folder_id = var.yc_folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-k8s.id}"
}