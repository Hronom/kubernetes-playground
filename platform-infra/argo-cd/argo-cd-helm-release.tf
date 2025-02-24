resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.4"
  namespace        = "argo-cd"
  create_namespace = false
  wait             = true
  timeout          = 900
  values = [
    yamlencode({
      "nameOverride" : "argo-cd"

      ### Inspired by https://github.com/argoproj/argo-cd/issues/2784
      "dex" : {
        "enabled" : false
      },

      "global" : {
        "additionalLabels" : {
          "env" : var.environment,
          "teamId" : var.team_id
        },
        "logging" : {
          "format" : "json",
          "level" : "warn"
        }
      },

      "redis" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "metrics" : {
          "enabled" : true
        }
      },

      "redis-ha" : {
        "enabled" : false,
        "haproxy" : {
          "metrics" : {
            "enabled" : true
          }
        }
      },

      "controller" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "replicas" : 1,
        "logLevel" : "warn",
        "metrics" : {
          "enabled" : true
        }
      },

      "server" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "autoscaling" : {
          "enabled" : false,
          "minReplicas" : 1
        },
        "logLevel" : "warn",
        "extraArgs" : [
          "--insecure"
        ],
        "metrics" : {
          "enabled" : true
        }
      },

      "repoServer" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "autoscaling" : {
          "enabled" : false,
          "minReplicas" : 1
        },
        "logLevel" : "warn",
        "metrics" : {
          "enabled" : true
        }
      },

      "applicationSet" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "replicaCount" : 1,
        "service" : {
          "portName" : "http-webhook"
        },
        "logLevel" : "warn",
        "metrics" : {
          "enabled" : true
        }
      },

      "notifications" : {
        "podAnnotations" : {
          "proxy.istio.io/config" : <<EOF
              holdApplicationUntilProxyStarts : true
              proxyMetadata :
                ISTIO_META_DNS_CAPTURE: "true"
                ISTIO_META_DNS_AUTO_ALLOCATE: "true"
                ISTIO_META_IDLE_TIMEOUT: "0s"
          EOF
        }
        "logLevel" : "warn",
        "metrics" : {
          "enabled" : true
        }
      },

      "configs" : {
        "params" : {
          "applicationsetcontroller.enable.new.git.file.globbing" : true
        }
        "cm" : {
          "url" : "http://argo-cd.${var.environment}.in.localhost",
          "timeout.reconciliation" : "60s",
          "application.resourceTrackingMethod" : "annotation+label",
          "exec.enabled" : true
        },
        "rbac" : {
          # RBAC Configuration doc https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/
          # Code below copied from https://github.com/argoproj/argo-cd/blob/master/assets/builtin-policy.csv
          # with some modifications
          "policy.csv" : <<EOF
              # Built-in policy which defines two roles: role:readonly and role:admin,
              # and additionally assigns the admin user to the role:admin role.
              # There are two policy formats:
              # 1. Applications, logs, and exec (which belong to a project):
              # p, <user/group>, <resource>, <action>, <project>/<object>
              # 2. All other resources:
              # p, <user/group>, <resource>, <action>, <object>

              # role:admin
              p, role:admin, applications, get, */*, allow
              p, role:admin, applications, create, */*, allow
              p, role:admin, applications, update, */*, allow
              p, role:admin, applications, delete, */*, allow
              p, role:admin, applications, sync, */*, allow
              p, role:admin, applications, override, */*, allow
              p, role:admin, applications, action/*, */*, allow
              p, role:admin, applicationsets, get, */*, allow
              p, role:admin, applicationsets, create, */*, allow
              p, role:admin, applicationsets, update, */*, allow
              p, role:admin, applicationsets, delete, */*, allow
              p, role:admin, certificates, get, *, allow
              p, role:admin, certificates, create, *, allow
              p, role:admin, certificates, update, *, allow
              p, role:admin, certificates, delete, *, allow
              p, role:admin, clusters, get, *, allow
              p, role:admin, clusters, create, *, allow
              p, role:admin, clusters, update, *, allow
              p, role:admin, clusters, delete, *, allow
              p, role:admin, repositories, get, *, allow
              p, role:admin, repositories, create, *, allow
              p, role:admin, repositories, update, *, allow
              p, role:admin, repositories, delete, *, allow
              p, role:admin, projects, get, *, allow
              p, role:admin, projects, create, *, allow
              p, role:admin, projects, update, *, allow
              p, role:admin, projects, delete, *, allow
              p, role:admin, accounts, get, *, allow
              p, role:admin, accounts, update, *, allow
              p, role:admin, gpgkeys, get, *, allow
              p, role:admin, gpgkeys, create, *, allow
              p, role:admin, gpgkeys, delete, *, allow
              p, role:admin, logs, get, */*, allow
              p, role:admin, exec, create, */*, allow

              # Groups association with roles
              g, admin, role:admin
          EOF
        }
      },

      "extraObjects" : [
        {
          "apiVersion" : "external-secrets.io/v1beta1",
          "kind" : "ExternalSecret",
          "metadata" : {
            "name" : "argo-cd-secret",
            "labels" : {
              "app.kubernetes.io/name" : "argo-cd-secret",
              "app.kubernetes.io/part-of" : "argo-cd"
            }
          },
          "spec" : {
            "refreshInterval" : "1h",
            "secretStoreRef" : {
              "name" : "local",
              "kind" : "ClusterSecretStore"
            },
            "target" : {
              # Secret in Argo CD has hardcoded old name: argocd-secret
              # Issue: https://github.com/argoproj/argo-helm/issues/2078
              "name" : "argocd-secret",
              "creationPolicy" : "Merge",
              "deletionPolicy" : "Retain"
            },
            "data" : [
              {
                "secretKey" : "admin.password",
                "remoteRef" : {
                  "key" : "/${var.environment}/argo-cd/admin/password/bcrypt"
                }
              }
            ]
          }
        },
        {
          "apiVersion" : "networking.istio.io/v1",
          "kind" : "VirtualService",
          "metadata" : {
            "name" : "argo-cd",
            "namespace" : "argo-cd"
          },
          "spec" : {
            "hosts" : [
              "argo-cd.${var.environment}.in.localhost"
            ],
            "gateways" : [
              "istio-gateway-ingress/istio-gateway-ingress-main"
            ],
            "http" : [
              {
                "route" : [
                  {
                    "destination" : {
                      "host" : "argo-cd-server",
                      "port" : {
                        "number" : 80
                      }
                    }
                  }
                ]
              }
            ]
          }
        }
      ]
    })
  ]
}
