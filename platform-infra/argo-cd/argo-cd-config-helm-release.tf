resource "helm_release" "argo_cd_platform_applications_config" {
  name             = "argo-cd-platform-applications-config"
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
          "apiVersion" : "argoproj.io/v1alpha1"
          "kind" : "AppProject"
          "metadata" : {
            "finalizers" : [
              "resources-finalizer.argocd.argoproj.io",
            ]
            "name" : "platform-applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "clusterResourceWhitelist" : [
              {
                "group" : "*"
                "kind" : "*"
              },
            ]
            "description" : "Project containing platform applications"
            "destinations" : [
              {
                # Fix inspired by https://github.com/argoproj/argo-cd/issues/16845#issuecomment-2141633904
                "name" : "*"
                "namespace" : "*"
                "server" : "https://kubernetes.default.svc"
              },
            ]
            "sourceRepos" : [
              "*",
            ]
          }
        },
        {
          "apiVersion" : "argoproj.io/v1alpha1"
          "kind" : "ApplicationSet"
          "metadata" : {
            "annotations" : {
              "argocd.argoproj.io/sync-wave" : "3"
            }
            "name" : "platform-applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "generators" : [
              {
                "git" : {
                  "files" : [
                    {
                      "path" : "platform-applications-${var.environment}/services/*/main.yaml"
                    }
                  ]
                  "repoURL" : "https://github.com/Hronom/kubernetes-playground.git"
                  "revision" : "HEAD"
                }
              },
            ]
            "template" : {
              "metadata" : {
                "name" : "{{ name }}"
              }
              "spec" : {
                "destination" : {
                  "namespace" : "{{ namespace }}"
                  "server" : "https://kubernetes.default.svc"
                }
                "ignoreDifferences" : [
                  {
                    "group" : "networking.istio.io"
                    "jqPathExpressions" : [
                      ".spec.http[].route[].weight",
                    ]
                    "kind" : "VirtualService"
                  },
                  {
                    "group" : "argoproj.io"
                    "jqPathExpressions" : [
                      ".spec.replicas",
                    ]
                    "kind" : "Rollout"
                  },
                ]
                "project" : "platform-applications"
                "source" : {
                  "helm" : {
                    "valueFiles" : [
                      "../../services/main.yaml",
                      "../../services/{{ name }}/main.yaml",
                    ]
                  }
                  "path" : "platform-applications-${var.environment}/profiles/{{ profile }}"
                  "repoURL" : "https://github.com/Hronom/kubernetes-playground.git"
                  "targetRevision" : "HEAD"
                }
                "syncPolicy" : {
                  "managedNamespaceMetadata" : {
                    "labels" : {
                      "istio-injection" : "{{ istio-injection }}"
                    }
                  }
                  "syncOptions" : [
                    "CreateNamespace=true",
                    "ApplyOutOfSyncOnly=true",
                  ]
                }
              }
            }
            "syncPolicy" : {
              "preserveResourcesOnDeletion" : true
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.argo_cd,
    helm_release.argo_cd_serviceentry_config,
    helm_release.argo_cd_repository_platform_applications_config
  ]
}

resource "helm_release" "argo_cd_applications_config" {
  name             = "argo-cd-applications-config"
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
          "apiVersion" : "argoproj.io/v1alpha1"
          "kind" : "AppProject"
          "metadata" : {
            "finalizers" : [
              "resources-finalizer.argocd.argoproj.io",
            ]
            "name" : "applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "clusterResourceWhitelist" : [
              {
                "group" : "*"
                "kind" : "*"
              },
            ]
            "description" : "Project containing applications"
            "destinations" : [
              {
                # Fix inspired by https://github.com/argoproj/argo-cd/issues/16845#issuecomment-2141633904
                "name" : "*"
                "namespace" : "*"
                "server" : "https://kubernetes.default.svc"
              },
            ]
            "sourceRepos" : [
              "*",
            ]
          }
        },
        {
          "apiVersion" : "argoproj.io/v1alpha1"
          "kind" : "ApplicationSet"
          "metadata" : {
            "annotations" : {
              "argocd.argoproj.io/sync-wave" : "3"
            }
            "name" : "applications"
            "namespace" : "argo-cd"
          }
          "spec" : {
            "generators" : [
              {
                "git" : {
                  "files" : [
                    {
                      "path" : "applications-${var.environment}/services/*/main.yaml"
                    },
                  ]
                  "repoURL" : "https://github.com/Hronom/kubernetes-playground.git"
                  "revision" : "HEAD"
                }
              },
            ]
            "template" : {
              "metadata" : {
                "name" : "{{ name }}",
                "annotations" : {
                  "originalName" : "{{ name }}"
                  "sourceCodeRepositoryUrl" : "{{ sourceCode.repositoryUrl }}"
                  "sourceCodeCommitSha" : "{{ sourceCode.commitSha }}"
                },
                "labels": {
                  "teamId": "{{ metadata.owner.team.id }}"
                }
              }
              "spec" : {
                "destination" : {
                  "namespace" : "{{ name }}-a"
                  "server" : "https://kubernetes.default.svc"
                }
                "ignoreDifferences" : [
                  {
                    "group" : "networking.istio.io"
                    "jqPathExpressions" : [
                      ".spec.http[].route[].weight",
                    ]
                    "kind" : "VirtualService"
                  },
                  {
                    "group" : "argoproj.io"
                    "jqPathExpressions" : [
                      ".spec.replicas",
                    ]
                    "kind" : "Rollout"
                  },
                ]
                "project" : "applications"
                "source" : {
                  "helm" : {
                    "valueFiles" : [
                      "../../services/main.yaml",
                      "../../services/{{ name }}/main.yaml",
                    ]
                  }
                  "path" : "applications-${var.environment}/profiles/{{ profile }}"
                  "repoURL" : "https://github.com/Hronom/kubernetes-playground.git"
                  "targetRevision" : "HEAD"
                }
                "syncPolicy" : {
                  "managedNamespaceMetadata" : {
                    "labels" : {
                      "istio-injection" : "enabled"
                    }
                  }
                  "syncOptions" : [
                    "CreateNamespace=true",
                    "ApplyOutOfSyncOnly=true",
                  ]
                }
                "info" : [
                  {
                    "name" : "Owner team name:",
                    "value" : "{{ metadata.owner.team.name }}"
                  }
                ]
              }
            }
            "syncPolicy" : {
              "preserveResourcesOnDeletion" : true
            }
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.argo_cd,
    helm_release.argo_cd_serviceentry_config,
    helm_release.argo_cd_repository_applications_config
  ]
}