# tenzu-front

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart to run the SPA frontend of Tenzu

**Homepage:** <https://tenzu.net/docs>

## Values

> [!IMPORTANT]
> A lot of the the values are described as being used to populate some json config value,
> you can find the description of those values in the [documentation](https://tenzu.net/docs/configuration#configure-tenzu-frontend)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | will use .Chart.Name | Used by name template: to fill the app.kubernetes.io/name label |
| fullnameOverride | string | will use .Release.Name suffixed with name template, if .Release.Name does not already contains it | Used by fullname template: to fill the name of all created kubernetes component |
| replicaCount | int | `1` | number of pod replicas for the frontend Deployment if not using autoscaling see: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| sentry.enabled | bool | `false` | Whether to set the environment variable expected by the error tracker |
| sentry.dsn | string | `nil` | Used to populate json config `sentry.dsn` |
| sentry.environment | string | `nil` | Used to populate json config `sentry.environment`, sentry.release will be set using the image.tag value when docker image is built |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/biru-scop/tenzu-back","tag":"latest"}` | Image to use for the application see: https://kubernetes.io/docs/concepts/containers/images/ |
| image.tag | string | `"latest"` | Overrides the image tag |
| imagePullSecrets | list | `nil` | List of secrets needed to pull an image from a private repository see: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | service account properties |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | If create is true, a name is generated using the fullname template, else it will be set to "default" | The name of the service account to use. |
| podAnnotations | object | `{}` | Extra annotation to put on frontend Deployment object see: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Extra labels to put on frontend Deployment object see: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{}` | definition of the pod level securityContext on frontend Deployment object |
| securityContext | object | `{}` | definition of the container level securityContext on frontend Deployment object |
| service | object | `{"port":80,"type":"ClusterIP"}` | see: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.type | string | `"ClusterIP"` | service type defined for the frontend |
| service.port | int | `80` | service port to access the frontend |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | properties used to define an Ingress see: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| ingress.className | string | `""` | will be used to set ingressClassName and "kubernetes.io/ingress.class" annotation depending on k8s version |
| ingress.annotations | object | Will set kubernetes.io/ingress.class to ingress.className if needed | ingress annotations, can be "kubernetes.io/ingress.class", "kubernetes.io/tls-acme", "cert-manager.io/cluster-issuer", etc. |
| ingress.hosts | list | `[]` | list of the hosts that will be exposed |
| ingress.tls | list | `[]` | Expect values in format {secretName: "", hosts: []}, If one of the domain in `ingress.hosts` is also defined as `global.backendUrl.host` You must take care to define tls for it if you also set `global.backendUrl.scheme` to "https" |
| resources | object | `{}` | container's resources definition set on every jobs and on the frontend Deployment object, If you want to set it, use the following format: `{limits: {cpu: 100m, memory: 128Mi}, requests: cpu: 100m, memory: 128Mi}}` |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | livenessProbe for the container of the frontend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | readinessProbe for the container of the frontend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | Whether to define a HorizontalPodAutoscaler with the following scaling properties on cpu and memory consumption see: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| nodeSelector | object | `{}` | nodeSelector pod property for the frontend Deployment object |
| tolerations | list | `[]` | tolerations pod property for the frontend Deployment object |
| affinity | object | `{}` | affinity pod property for the frontend Deployment object |
| volumes | list | `[]` | Additional volumes for the frontend Deployment object |
| volumeMounts | list | `[]` | Additional volumeMounts for the frontend Deployment object |
| global | object | `{"backendUrl":{"host":null,"scheme":"https","websocketScheme":"wss"}}` | global values to share properties among charts. |
| global.backendUrl | object | `{"host":null,"scheme":"https","websocketScheme":"wss"}` | url used to serve the backend, will be used to set json config `api.baseDomain`, `api.scheme` and `wsUrl` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)