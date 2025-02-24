<!-- TOC -->
* [Intro](#intro)
* [platform-infra](#platform-infra)
  * [01 external-secrets](#01-external-secrets)
  * [02 istio](#02-istio)
  * [03 argo-cd](#03-argo-cd)
* [platform-applications-prod](#platform-applications-prod)
  * [Temporal](#temporal)
  * [n8n](#n8n)
* [applications-prod](#applications-prod)
<!-- TOC -->

# Intro
Commands and helm charts are ready to use in Kubernetes that running inside Docker Desktop.

# platform-infra
## 01 external-secrets
```shell
cd platform-infra/external-secrets
terraform init --backend-config="path=terraform-prod.tfstate" --reconfigure
```

```shell
cd platform-infra/external-secrets
terraform apply --var-file=inputs-prod.tfvars -auto-approve
```

## 02 istio
```shell
cd platform-infra/istio
terraform init --backend-config="path=terraform-prod.tfstate" --reconfigure
```

```shell
cd platform-infra/istio
terraform apply --var-file=inputs-prod.tfvars -auto-approve
```

## 03 argo-cd
```shell
cd platform-infra/argo-cd
terraform init --backend-config="path=terraform-prod.tfstate" --reconfigure
```

```shell
cd platform-infra/argo-cd
terraform apply --var-file=inputs-prod.tfvars -auto-approve
```

Username: `admin`
Password: `admin`

# platform-applications-prod
Add custom helm chart.

If it has dependencies, run:
```shell
helm dependency build
```

## Temporal
On Linux add inside `/etc/hosts` record:
```
127.0.0.1 temporal.localhost
```

On other systems check where it should be added=)

## n8n
On Linux add inside `/etc/hosts` record:
```
127.0.0.1 n8n.localhost
```

On other systems check where it should be added=)

# applications-prod