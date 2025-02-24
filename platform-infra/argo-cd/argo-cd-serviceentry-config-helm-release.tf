resource "helm_release" "argo_cd_serviceentry_config" {
  name             = "argo-cd-serviceentry-config"
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
          "apiVersion" : "networking.istio.io/v1alpha3"
          "kind" : "ServiceEntry"
          "metadata" : {
            "name" : "github-com"
          }
          "spec" : {
            "hosts" : [
              "github.com",
            ]
            "location" : "MESH_EXTERNAL"
            "ports" : [
              {
                "name" : "https"
                "number" : 443
                "protocol" : "https"
              },
            ]
            "resolution" : "DNS"
          }
        }
      ]
    })
  ]

  depends_on = [
    helm_release.argo_cd
  ]
}
