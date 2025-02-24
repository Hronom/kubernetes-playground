resource "helm_release" "argo_cd_repository_platform_applications_config" {
  name             = "argo-cd-repository-platform-applications-config"
  repository       = "https://bedag.github.io/helm-charts/"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "argo-cd"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "resources" : [
        {
          "apiVersion" : "external-secrets.io/v1beta1"
          "kind" : "ExternalSecret"
          "metadata" : {
            "labels" : {
              "argocd.argoproj.io/secret-type" : "repository"
            }
            "name" : "argo-cd-repository-platform-applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "data" : [
              {
                "remoteRef" : {
                  "key" : "/${var.environment}/github/platform-applications-${var.environment}/pat/argo-cd"
                }
                "secretKey" : "password"
              },
            ]
            "refreshInterval" : "1h"
            "secretStoreRef" : {
              "kind" : "ClusterSecretStore"
              "name" : "local"
            }
            "target" : {
              "creationPolicy" : "Owner"
              "deletionPolicy" : "Delete"
              "name" : "argo-cd-repository-platform-applications"
              "template" : {
                "data" : {
                  # "password" : "{{ .password }}"
                  "type" : "git"
                  "url" : "https://github.com/Hronom/kubernetes-playground"
                  # "username" : "non-empty-username"
                }
                "metadata" : {
                  "labels" : {
                    "argocd.argoproj.io/secret-type" : "repository"
                  }
                }
              }
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.argo_cd,
    helm_release.argo_cd_serviceentry_config
  ]
}

resource "helm_release" "argo_cd_repository_applications_config" {
  name             = "argo-cd-repository-applications-config"
  repository       = "https://bedag.github.io/helm-charts/"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "argo-cd"
  create_namespace = false
  wait             = true
  values = [
    yamlencode({
      "resources" : [
        {
          "apiVersion" : "external-secrets.io/v1beta1"
          "kind" : "ExternalSecret"
          "metadata" : {
            "labels" : {
              "argocd.argoproj.io/secret-type" : "repository"
            }
            "name" : "argo-cd-repository-applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "data" : [
              {
                "remoteRef" : {
                  "key" : "/${var.environment}/github/applications-${var.environment}/pat/argo-cd"
                }
                "secretKey" : "password"
              },
            ]
            "refreshInterval" : "1h"
            "secretStoreRef" : {
              "kind" : "ClusterSecretStore"
              "name" : "local"
            }
            "target" : {
              "creationPolicy" : "Owner"
              "deletionPolicy" : "Delete"
              "name" : "argo-cd-repository-applications"
              "template" : {
                "data" : {
                  # "password" : "{{ .password }}"
                  "type" : "git"
                  "url" : "https://github.com/Hronom/kubernetes-playground"
                  # "username" : "non-empty-username"
                }
                "metadata" : {
                  "labels" : {
                    "argocd.argoproj.io/secret-type" : "repository"
                  }
                }
              }
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.argo_cd,
    helm_release.argo_cd_serviceentry_config
  ]
}