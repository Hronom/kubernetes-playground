resource "helm_release" "istio_gateway_ingress_main" {
  name             = "istio-gateway-ingress-main"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = "1.24.3"
  namespace        = "istio-gateway-ingress"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "labels" : {
        "env" : var.environment,
        "teamId" : var.team_id
      },

      "replicaCount" : var.istio_gateway_ingress_main_min_replica_count,

      "autoscaling" : {
        "minReplicas" : var.istio_gateway_ingress_main_min_replica_count,
        "maxReplicas" : var.istio_gateway_ingress_main_max_replica_count
      },

      "service" : {
        "type" : "LoadBalancer",
        "ports" : [
          {
            "name" : "http-status-port",
            "port" : 15100,
            "protocol" : "TCP",
            "targetPort" : 15021
          },
          {
            "name" : "http2",
            "port" : 80,
            "protocol" : "TCP",
            "targetPort" : 80
          },
          {
            "name" : "https",
            "port" : 443,
            "protocol" : "TCP",
            "targetPort" : 443
          }
        ]
      }
    })
  ]

  depends_on = [
    helm_release.istio_istiod_config,
    kubernetes_namespace.istio_gateway_ingress
  ]
}

resource "helm_release" "istio_gateway_ingress_config" {
  name             = "istio-gateway-ingress-config"
  repository       = "https://bedag.github.io/helm-charts/"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "istio-gateway-ingress"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "resources" : [
        {
          "apiVersion" : "networking.istio.io/v1alpha3"
          "kind" : "Gateway"
          "metadata" : {
            "name" : "istio-gateway-ingress-main"
            "namespace" : "istio-gateway-ingress"
          }
          "spec" : {
            "selector" : {
              "app" : "istio-gateway-ingress-main"
            }
            "servers" : [
              {
                "hosts" : [
                  "*",
                ]
                "port" : {
                  "name" : "http2"
                  "number" : 80
                  "protocol" : "HTTP2"
                }
              },
            ]
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.istio_gateway_ingress_main
  ]
}
