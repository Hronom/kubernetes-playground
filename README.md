<!-- TOC -->
* [Intro](#intro)
* [platform-infra](#platform-infra)
  * [01 external-secrets](#01-external-secrets)
  * [02 istio](#02-istio)
  * [03 argo-cd](#03-argo-cd)
* [platform-applications-prod](#platform-applications-prod)
  * [Argo Rollouts](#argo-rollouts)
  * [Temporal](#temporal)
  * [n8n](#n8n)
* [applications-prod](#applications-prod)
<!-- TOC -->

# Intro
This repo shows GitOps, IaC approach to managing runtime environment using Argo CD.
Also, we use Istio for secure(strict mTLS) service to service communications.

To run, you must have the latest version of Docker Desktop with Kubernetes enabled.

Repo structure:
1. `platform-infra` - contains base infrastructure managed by terraform to prepare and configure base for runtime environment
2. `platform-applications-prod` - this is a GitOps repo used by Argo CD to sync state for `prod` platform applications
3. `applications-prod` - this is a GitOps repo used by Argo CD to sync state for `prod` applications

# platform-infra
This folder contains terraform scripts with basic setup for the platform based on Kubernetes and docker-desktop.

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

On Linux add inside `/etc/hosts` record:
```
127.0.0.1 argo-cd.prod.in.localhost
```

# platform-applications-prod
This is a GitOps repo used by Argo CD to sync state for prod platform applications.

Add custom helm chart.

If it has dependencies, run:
```shell
helm dependency build
```

## Argo Rollouts
On Linux add inside `/etc/hosts` record:
```
127.0.0.1 argo-rollouts.prod.in.localhost
```

## Temporal
On Linux add inside `/etc/hosts` record:
```
127.0.0.1 temporal.prod.in.localhost
```

On other systems check where it should be added=)

## n8n
On Linux add inside `/etc/hosts` record:
```
127.0.0.1 n8n.prod.in.localhost
```

On other systems check where it should be added=)

# applications-prod
This is a GitOps repo used by Argo CD to sync state for prod applications.