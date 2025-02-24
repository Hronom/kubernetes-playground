resource "kubernetes_namespace" "argo_cd" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "argo-cd"
  }
}
