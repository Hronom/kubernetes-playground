resource "kubernetes_namespace" "istio_system" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "istio-system"
  }
}

resource "kubernetes_labels" "default" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    istio-injection = "enabled"
  }
}
