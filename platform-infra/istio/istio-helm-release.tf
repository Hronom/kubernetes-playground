resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.24.3"
  namespace        = "istio-system"
  create_namespace = false
  wait             = true

  depends_on = [
    kubernetes_namespace.istio_system,
    kubernetes_labels.default
  ]
}

resource "helm_release" "istio_istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = "1.24.3"
  namespace        = "istio-system"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "global" : {
        "logAsJson" : true,
        "logging" : {
          "level" : "all:warn"
        }
      },

      "pilot" : {
        "deploymentLabels" : {
          "env" : var.environment,
          "teamId" : var.team_id
        },

        "podLabels" : {
          "env" : var.environment,
          "teamId" : var.team_id
        },

        "autoscaleMin" : var.istio_istiod_min_replica_count,
        "autoscaleMax" : var.istio_istiod_max_replica_count,
        "replicaCount" : var.istio_istiod_min_replica_count,

        # https://istio.io/latest/docs/reference/commands/pilot-agent/#envvars
        "env" : {
          "ENABLE_NATIVE_SIDECARS" : "true"
          # Inspired by https://istio.io/latest/docs/ops/configuration/traffic-management/dns-proxy/#dns-auto-allocation-v2
          "PILOT_ENABLE_IP_AUTOALLOCATE" : "true"
        }
      },

      # https://istio.io/latest/docs/reference/config/istio.mesh.v1alpha1/#MeshConfig
      "meshConfig" : {
        "outboundTrafficPolicy" : {
          "mode" : "REGISTRY_ONLY"
        },
        "defaultConfig" : {
          # https://istio.io/latest/docs/reference/config/istio.mesh.v1alpha1/#ProxyConfig-TracingServiceName
          # https://github.com/istio/istio/issues/36162#issuecomment-1825041115
          # https://istio.slack.com/archives/C382V8Q92/p1700787847380659
          "tracingServiceName" : "CANONICAL_NAME_ONLY",
          "proxyMetadata" : {
            # Inspired by https://istio.io/latest/docs/ops/configuration/traffic-management/dns-proxy/#dns-auto-allocation-v2
            "ISTIO_META_DNS_CAPTURE" : "true"
          }
        }
      }
    })
  ]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_istiod_config" {
  name             = "istiod-config"
  repository       = "https://bedag.github.io/helm-charts/"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "istio-system"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "resources" : [
        # Follow best practice and set strict mode for mutual TLS:
        # https://istio.io/latest/docs/ops/best-practices/security/#mutual-tls
        {
          "apiVersion" : "security.istio.io/v1beta1",
          "kind" : "PeerAuthentication",
          "metadata" : {
            "name" : "default"
          },
          "spec" : {
            "mtls" : {
              "mode" : "STRICT"
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.istio_istiod
  ]
}
