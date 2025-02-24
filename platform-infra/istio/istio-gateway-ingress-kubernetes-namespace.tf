resource "kubernetes_namespace" "istio_gateway_ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "istio-gateway-ingress"
  }
}
