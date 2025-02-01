<!-- TOC -->
* [Intro](#intro)
* [Install applications](#install-applications)
  * [Install base applications](#install-base-applications)
    * [Install Istio](#install-istio)
    * [Install Istio Ingress](#install-istio-ingress)
  * [Install extra applications](#install-extra-applications)
    * [Install Temporal](#install-temporal)
<!-- TOC -->

# Intro
Commands and helm charts are ready to use in Kubernetes that running inside Docker Desktop.

# Install applications
## Install base applications
### Install Istio

```shell
kubectl create namespace istio-system
```

```shell
helm upgrade --dependency-update --install istio-base-custom ./istio/istio-base-custom --namespace istio-system
```

```shell
helm upgrade --dependency-update --install istio-istiod-custom ./istio/istio-istiod-custom --namespace istio-system
```

```shell
helm upgrade --dependency-update --install istio-istiod-config-custom ./istio/istio-istiod-config-custom --namespace istio-system
```

### Install Istio Ingress
```shell
kubectl create namespace istio-ingress
```

```shell
helm upgrade --dependency-update --install istio-gateway-custom ./istio/istio-gateway-custom --namespace istio-ingress
```

```shell
helm upgrade --dependency-update --install istio-gateway-config-custom ./istio/istio-gateway-config-custom --namespace istio-ingress
```

## Install extra applications
### Install Temporal
```shell
kubectl create namespace temporal
kubectl label namespaces temporal istio-injection=enabled --overwrite=true
```

```shell
helm upgrade --dependency-update --install temporal-postgresql ./temporal/temporal-postgresql --namespace temporal
```

```shell
helm upgrade --dependency-update --install temporal-custom ./temporal/temporal-custom --namespace temporal
```

On Linux add inside `/etc/hosts` record:
```
127.0.0.1 temporal.localhost
```

On other systems check where it should be added=)