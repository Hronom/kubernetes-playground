resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.14.2"
  namespace        = "external-secrets"
  create_namespace = true
  wait             = true
  values = [
    yamlencode({
      "commonLabels" : {
        "env" : var.environment,
        "teamId" : var.team_id
      },

      "extraArgs" : {
        "loglevel" : "warn"
      },

      "webhook" : {
        "extraArgs" : {
          "loglevel" : "warn"
        }
      },

      "certController" : {
        "extraArgs" : {
          "loglevel" : "warn"
        }
      }
    })
  ]
}

resource "helm_release" "external_secrets_config" {
  name             = "external-secrets-config"
  repository       = "https://bedag.github.io/helm-charts/"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "external-secrets"
  create_namespace = true
  wait             = true
  values = [
    yamlencode({
      "resources" : [
        {
          "apiVersion" : "external-secrets.io/v1beta1"
          "kind" : "ClusterSecretStore"
          "metadata" : {
            "name" : "local",
            "namespace" : "external-secrets"
          }
          "spec" : {
            "provider" : {
              "fake" : {
                "data" : [
                  {
                    "key" : "/${var.environment}/argo-cd/admin/password/bcrypt"
                    "value" : "$2a$12$3ixOLxbYgKp.1BuYnLhGt.r06NSoTJKI5i/4hdhTyG7ArI7t.Uz0."
                  },
                  {
                    "key" : "/${var.environment}/github/platform-applications-${var.environment}/pat/argo-cd"
                    "value" : "non-empty-pat"
                  },
                  {
                    "key" : "/${var.environment}/github/applications-${var.environment}/pat/argo-cd"
                    "value" : "non-empty-pat"
                  }
                ]
              }
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.external_secrets
  ]
}

