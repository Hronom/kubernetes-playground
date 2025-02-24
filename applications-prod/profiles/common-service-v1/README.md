# common-service-v1

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)

Chart for common service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| allowAnyExternalServices | bool | `false` | Allow service to access ANY other external(outside Kubernetes) service |
| authorizations.rules | list | `[]` (See [values.yaml]) | Rules about what service can access what endpoints |
| autoscaler.horizontal.behavior.scaleDown.stabilizationWindowSeconds | int | `300` | The [stabilization window](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#stabilization-window) is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating |
| autoscaler.horizontal.behavior.scaleUp.stabilizationWindowSeconds | int | `5` | The [stabilization window](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#stabilization-window) is used to restrict the flapping of replica count when the metrics used for scaling keep fluctuating |
| autoscaler.horizontal.triggers.cpu.averageUtilization | int | `80` | Average utilization of the cpu. If goes above value mentioned here - scale up |
| autoscaler.horizontal.triggers.cpu.enabled | bool | `true` | Enable CPU horizontal autoscaler |
| autoscaler.horizontal.triggers.istioRequestsPerSecond.averageValue | string | `"50"` | Average utilization of the istioRequestsPerSecond. If goes above value mentioned here - scale up. |
| autoscaler.horizontal.triggers.istioRequestsPerSecond.enabled | bool | `false` | Enable istioRequestsPerSecond horizontal autoscaler |
| autoscaler.maxReplicas | int | `4` | Max replicas count |
| autoscaler.minReplicas | int | `2` | Min replicas count |
| container.additionalPorts | list | `[]` (See [values.yaml]) | Additional ports for container to expose |
| container.args | list | `[]` | The arguments that you define in the configuration file override the default arguments provided by the container image. If you define args, but do not define a command, the default command is used with your new arguments. [Define a Command and Arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container) |
| container.command | list | `[]` | The command that you define in the configuration file override the default command provided by the container image. [Define a Command and Arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container) |
| container.env | object | `{}` (See [values.yaml]) | Environment variables |
| container.envSecret | list | `[]` (See [values.yaml]) | Secrets that passed through environment variables |
| container.httpMainPort | int | `3000` | HTTP main port that application listens to |
| container.livenessProbe | object | `{}` (See [values.yaml]) | This allows Kubernetes to know whether the application within the container is still working |
| container.readinessProbe | object | `{}` (See [values.yaml]) | It's a way for Kubernetes to know when a Pod is ready to start accepting traffic |
| container.resources.limits.cpu | string | `"250m"` | Max amount of cpu that a container can use. If the container goes above the limit - it will be killed. [CPU resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) |
| container.resources.limits.ephemeralStorage | string | `"1Gi"` | Max amount of storage that a container can use. If the container goes above the limit - it will be killed. [Local ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) |
| container.resources.limits.memory | string | `"500Mi"` | Max amount of memory that a container can use. If the container goes above the limit - it will be killed. [Memory resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) |
| container.resources.requests.cpu | string | `"250m"` | How much cpu to request initially. If the container goes above requested resources, it will be highly likely evicted. [CPU resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) |
| container.resources.requests.ephemeralStorage | string | `"1Gi"` | How much storage to request initially. If the container goes above requested resources, it will be highly likely evicted. [Local ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#local-ephemeral-storage) |
| container.resources.requests.memory | string | `"500Mi"` | How much memory to request initially. If the container goes above requested resources, it will be highly likely evicted. [Memory resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) |
| container.securityContext.runAsGroup | int | `0` | What user group to use |
| container.securityContext.runAsUser | int | `0` | As what user to run |
| container.startupProbe | object | `{}` (See [values.yaml]) | It is intended to be used to check if an application within a Docker container has started. If the startup probe fails, Kubernetes will kill the container, and the container is subject to the pod's restart policy |
| deployLink | string | `""` | Link to the app deployment |
| dockerRepository | string | `""` | Docker repository |
| dockerRepositoryHost | string | `"docker.io"` | Host for docker repository |
| environment | string | `""` | Environment |
| gateways | list | `[]` | Istio gateways from that service expect to receive traffic. Gateways should be referred to by istio-gateway-ingress/<gateway name> |
| headlessService.additionalPorts | list | `[]` (See [values.yaml]) | Additional ports for headless service to expose for other services |
| headlessService.enabled | bool | `false` |  |
| hosts | list | `[]` | Urls used by istio gateways to route traffic to this service |
| httpMatch | list | `[{"uri":{"prefix":"/"}}]` | HTTP list of matchers that will be used to route traffic to this service |
| httpMatch[0] | object | `{"uri":{"prefix":"/"}}` | URI to match values are case-sensitive. More info about [possible approaches](https://istio.io/latest/docs/reference/config/networking/virtual-service/#StringMatch) |
| httpMatch[0].uri.prefix | string | `"/"` | HTTP prefix that will be used to route traffic to this service. Useful then several services use one host |
| kubernetes.api.clusterRole.rules | list | `[]` | List of cluster role rules |
| metadata.owner.team.id | string | `""` | Owner team id |
| metadata.owner.team.name | string | `""` | Owner team name |
| name | string | `""` | Service name in kebab-case |
| profile | string | `""` | App profile |
| rollout.abortScaleDownDelaySeconds | int | `30` | Add a delay in seconds before scaling down the new stack if update is aborted |
| rollout.dynamicStableScale | bool | `false` | The ability to dynamically scale the stable ReplicaSet, so old instances will shutdown as soon as new pod starts and becomes healthy. [Dynamic Stable Scale (with Traffic Routing)](https://argo-rollouts.readthedocs.io/en/stable/features/canary/#dynamic-stable-scale-with-traffic-routing) |
| rollout.progressDeadlineSeconds | int | `3600` | The maximum time in seconds in which a rollout must make progress during an update, before it is considered to be failed. Note that progress will not be estimated during the time a rollout is paused. |
| rollout.revisionHistoryLimit | int | `10` | The number of old stacks definitions to retain |
| rollout.rollbackWindowRevisions | int | `3` | [The rollback window](https://argo-rollouts.readthedocs.io/en/stable/features/rollback/) provides a way to fast track deployments to previously deployed versions. |
| rollout.scaleDownDelaySeconds | int | `300` | Adds a delay in seconds before scaling down the previous stack |
| rollout.steps | list | `[{"setCanaryScale":{"weight":100}},{"setWeight":5},{"pause":{"duration":"30s"}},{"setWeight":20},{"pause":{"duration":"30s"}},{"setWeight":40},{"pause":{"duration":"30s"}},{"setWeight":60},{"pause":{"duration":"30s"}},{"setWeight":80},{"pause":{"duration":"30s"}},{"setWeight":100}]` | List of steps the controller uses to manipulate the ReplicaSets. [Overview](https://argo-rollouts.readthedocs.io/en/stable/features/canary/#overview) |
| service.additionalPorts | list | `[]` (See [values.yaml]) | Additional ports for service to expose for other services |
| service.httpMainPort | int | `80` | HTTP main port for service to expose for other services |
| telemetry.prometheus.enabled | bool | `false` | Enable scraping of metrics from app that exposed in prometheus way |
| telemetry.prometheus.path | string | `"/actuator/prometheus"` | Prometheus metrics endpoint path |
| telemetry.prometheus.port | int | `3000` | Prometheus metrics endpoint port |
| terminationGracePeriodSeconds | int | `60` | Duration in seconds that the system should wait before destroying a pod after it has been marked for deletion. This time period is set to allow the pod to handle the SIGTERM signal and terminate gracefully. It might be useful in cases where the services running in the pod need to complete certain operations or release resources before closing. For example, a web server pod might need to finish serving any pending requests. |
| timeout | string | `"30s"` | Timeout for this service |
| traffic.interception.excludeInboundPorts.enabled | bool | `false` | Enables the exclusion of inbound ports. The Istio sidecar will not intercept these ports. This feature is useful for handling problematic third-party dependencies like Redis. |
| traffic.interception.excludeInboundPorts.list | list | `[]` | List of ports to exclude |
| traffic.interception.excludeOutboundPorts.enabled | bool | `false` | Enables the exclusion of outbound ports. The Istio sidecar will not intercept these ports. This feature is useful for handling problematic third-party dependencies like Redis. |
| traffic.interception.excludeOutboundPorts.list | list | `[]` | List of ports to exclude |
| traffic.warmupDurationSeconds | int | `30` | Newly created pod of service remains in warmup mode starting from its creation time for the duration of this window and Istio progressively increases amount of traffic for that pod instead of sending proportional amount of traffic. |
| version | string | `""` | Docker image version |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
