# tenzu

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart to run the full Tenzu web application

**Homepage:** <https://tenzu.net/docs>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../tenzu-back | tenzu-back | 0.1.5 |
| file://../tenzu-front | tenzu-front | 0.1.3 |
| https://charts.bitnami.com/bitnami/ | postgresql | 16.4.14 |
| https://charts.bitnami.com/bitnami/ | redis | 19.6.4 |

## Values

> [!IMPORTANT]
> A lot of the the values are described as being used to populate some environment variables or json config values,
> you can find the description of those in the [documentation](https://tenzu.net/docs/configuration)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"backendUrl":{"host":null,"scheme":"https","websocketScheme":"wss"},"frontendUrl":{"host":null,"scheme":"https"},"postgresql":null,"redis":null}` | global values to share properties among charts. |
| global.redis | object | `nil` | redis.password will be used to set `TENZU_EVENTS__REDIS_PASSWORD` if defined You still need to define redis.host as a local value. Useful if you're using bitnami/redis as this value will also be used |
| global.postgresql | object | `nil` | The expected global value for postgres is an object formatted like {auth: {password: string, username: string, database: string}}  in order to set respectively `TENZU_DB__PASSWORD`, `TENZU_DB__USER` and `TENZU_DB__NAME`. You still need to define postgres.host as a local value. Useful if you're using bitnami/postgresql as this value will also be used |
| global.backendUrl | object | `{"host":null,"scheme":"https","websocketScheme":"wss"}` | url used to serve the backend, will be used to set `TENZU_BACKEND_URL` If exposed via ingress, host should be the same as the ingress' and scheme must be coherent with ingress' tls |
| global.frontendUrl | object | `{"host":null,"scheme":"https"}` | url used to serve the frontend, will be used to set `TENZU_FRONTEND_URL` If exposed via ingress, host should be the same as the ingress' and scheme must be coherent with ingress' tls |
| postgresql.enabled | bool | `true` | Whether to enable bitnami provided postgresql chart as a dependency If you do, fill the postgresql parameters in global key so it can also be used by tenzu-back |
| redis.enabled | bool | `true` | Whether to enable bitnami provided redis chart as a dependency If you do, fill the redis parameters in global key so it can also be used by tenzu-back |
| tenzu-back.nameOverride | string | will use .Chart.Name | Used by name template: to fill the app.kubernetes.io/name label |
| tenzu-back.fullnameOverride | string | will use .Release.Name suffixed with name template, if .Release.Name does not already contains it | Used by fullname template: to fill the name of all created kubernetes component |
| tenzu-back.replicaCount | int | `1` | number of pod replicas for the api backend and the worker service if not using autoscaling see: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| tenzu-back.caddy.replicas | int | `1` |  |
| tenzu-back.workersQuantity | int | `1` | number workers started by gunicorn |
| tenzu-back.workersTimeout | int | `120` | timeout of workers used by gunicorn |
| tenzu-back.logLevel | string | `"warning"` | level of log produced by gunicorn |
| tenzu-back.sentry.enabled | bool | `false` | Whether to set the environment variable expected by the error tracker |
| tenzu-back.sentry.dsn | string | `nil` | Used to populate SENTRY_DSN |
| tenzu-back.sentry.environment | string | `nil` | Used to populate SENTRY_ENVIRONMENT, SENTRY_RELEASE will be set using the image.tag value |
| tenzu-back.secretKey | string | `nil` | Used to populate `TENZU_SECRET_KEY` |
| tenzu-back.tokenSigningKey | string | `nil` | Used to populate `TENZU_TOKENS__SIGNING_KEY` |
| tenzu-back.env | list | `[]` | additionnal environment variable to set on every jobs and on the backend and task queue Deployment objects. |
| tenzu-back.envFrom | list | `[]` | additionnal environment variable to set on every jobs and on the backend and task queue Deployment objects, fecthed from a seceret or config map |
| tenzu-back.email.tls | bool | `true` | Used to populate `TENZU_EMAIL__EMAIL_USE_TLS` |
| tenzu-back.email.ssl | bool | `false` | Used to populate `TENZU_EMAIL__EMAIL_USE_SSL` |
| tenzu-back.email.port | int | `547` | Used to populate `TENZU_EMAIL__EMAIL_PORT` |
| tenzu-back.email.defaultFrom | string | `nil` | Used to populate `TENZU_EMAIL__DEFAULT_FROM_EMAIL` |
| tenzu-back.email.host | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST` |
| tenzu-back.email.user | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST_USER` |
| tenzu-back.email.password | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST_PASSWORD` |
| tenzu-back.email.supportEmail | string | `nil` | Used to populate `TENZU_SUPPORT_EMAIL` |
| tenzu-back.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/biru-scop/tenzu-back","tag":"latest"}` | Image to use for the application see: https://kubernetes.io/docs/concepts/containers/images/ |
| tenzu-back.image.tag | string | Uses the .Chart.AppVersion if not set | Overrides the image tag |
| tenzu-back.imagePullSecrets | list | `nil` | List of secrets needed to pull an image from a private repository see: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| tenzu-back.serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | service account properties |
| tenzu-back.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| tenzu-back.serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials |
| tenzu-back.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| tenzu-back.serviceAccount.name | string | If create is true, a name is generated using the fullname template, else it will be set to "default" | The name of the service account to use. |
| tenzu-back.podAnnotations | object | `{}` | Extra annotation to put on backend and task queue Deployment objects see: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| tenzu-back.podLabels | object | `{}` | Extra labels to put on backend and task queue Deployment objects see: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| tenzu-back.podSecurityContext | object | `{}` | definition of the pod level securityContext on backend and task queue Deployment objects |
| tenzu-back.securityContext | object | `{}` | definition of the container level securityContext on backend and task queue Deployment objects |
| tenzu-back.service | object | `{"port":8000,"type":"ClusterIP"}` | see: https://kubernetes.io/docs/concepts/services-networking/service/ |
| tenzu-back.service.type | string | `"ClusterIP"` | service type defined for the backend and the reverse proxy |
| tenzu-back.service.port | int | `8000` | service port to access the backend |
| tenzu-back.ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | properties used to define an Ingress see: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| tenzu-back.ingress.className | string | `""` | will be used to set ingressClassName and "kubernetes.io/ingress.class" annotation depending on k8s version |
| tenzu-back.ingress.annotations | object | Will set kubernetes.io/ingress.class to ingress.className if needed | ingress annotations, can be "kubernetes.io/ingress.class", "kubernetes.io/tls-acme", "cert-manager.io/cluster-issuer", etc. |
| tenzu-back.ingress.hosts | list | `[]` | list of the hosts that will be exposed |
| tenzu-back.ingress.tls | list | `[]` | Expect values in format {secretName: "", hosts: []}, If one of the domain in `ingress.hosts` is also defined as `global.backendUrl/frontendUrl.host` You must take care to define tls for it if you also set `global.backendUrl/frontendUrl.scheme` to "https" |
| tenzu-back.resources | object | `{}` | container's resources definition set on every jobs and on the backend and task queue Deployment objects, If you want to set it, use the following format: `{limits: {cpu: 100m, memory: 128Mi}, requests: cpu: 100m, memory: 128Mi}}` |
| tenzu-back.livenessProbe | object | `{"httpGet":{"path":"/api/v1/healthcheck","port":8000}}` | livenessProbe for the container of the backend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| tenzu-back.readinessProbe | object | `{"httpGet":{"path":"/api/v1/healthcheck","port":8000}}` | readinessProbe for the container of the backend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| tenzu-back.autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | Whether to define a HorizontalPodAutoscaler with the following scaling properties on cpu and memory consumption see: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| tenzu-back.nodeSelector | object | `{}` | nodeSelector pod property for the backend and task queue Deployment objects |
| tenzu-back.tolerations | list | `[]` | tolerations pod property for the backend and task queue Deployment objects |
| tenzu-back.affinity | object | `{}` | affinity pod property for the backend and task queue Deployment objects |
| tenzu-back.cronJobs | list | `[]` | list of object in format {name: string, schedule: string, command: string[]} schedule and command should be set to the format expected by CronJob (see: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) |
| tenzu-back.persistentVolumeClaim.public | object | `{"accessModes":["ReadWriteMany"],"resources":{"requests":{"storage":"10Gi"}}}` | Spec of the PersistentVolumeClaim used by the volume for public files |
| tenzu-back.persistentVolumeClaim.public.resources.requests.storage | string | `"10Gi"` | Storage size for the PersistentVolumeClaim used by the volume for public files, change the capacity to what you need |
| tenzu-back.volumes | list | `[]` | Additional volumes for the backend and task queue Deployment objects |
| tenzu-back.volumeMounts | list | `[]` | Additional volumeMounts for the backend and task queue Deployment objects |
| tenzu-back.postgresql.auth | object | `{"database":null,"databaseKey":null,"existingSecret":null,"password":null,"passwordKey":null,"username":null,"usernameKey":null}` | To configure the postgresql connexion you can use global or local values. Local values can use an existing secret, direct values or a mix of both Only use on method for each expected value |
| tenzu-back.postgresql.auth.existingSecret | string | `nil` | existing secret where all necessary value can be found |
| tenzu-back.postgresql.auth.passwordKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__PASSWORD` |
| tenzu-back.postgresql.auth.databaseKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__NAME` |
| tenzu-back.postgresql.auth.usernameKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__USER` |
| tenzu-back.postgresql.auth.password | string | `nil` | password value, used to populate `TENZU_DB__PASSWORD` |
| tenzu-back.postgresql.auth.database | string | `nil` | database name value, used to populate `TENZU_DB__NAME` |
| tenzu-back.postgresql.auth.username | string | `nil` | username value, used to populate `TENZU_DB__USER` |
| tenzu-back.postgresql.host | string | `nil` | Used to populate `TENZU_DB__HOST` It can be something like tenzu-postgres.$NAMESPACE.svc.cluster.local |
| tenzu-back.redis.options | string | `"{\"health_check_interval\": 5}"` | Used to populate `TENZU_EVENTS__REDIS_OPTIONS` |
| tenzu-back.redis.host | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_HOST` It can be something like "tenzu-redis-headless.$NAMESPACE.svc.cluster.local" |
| tenzu-back.redis.password | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` using the passed value directly |
| tenzu-back.redis.existingSecret | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` If you want to use an existing secret for the password instead |
| tenzu-back.redis.passwordKey | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` If you use redis.existingSecret, you must set this key to the corresponding value to use in the secret |
| tenzu-front.nameOverride | string | will use .Chart.Name | Used by name template: to fill the app.kubernetes.io/name label |
| tenzu-front.fullnameOverride | string | will use .Release.Name suffixed with name template, if .Release.Name does not already contains it | Used by fullname template: to fill the name of all created kubernetes component |
| tenzu-front.replicaCount | int | `1` | number of pod replicas for the frontend Deployment if not using autoscaling see: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| tenzu-front.sentry.enabled | bool | `false` | Whether to set the environment variable expected by the error tracker |
| tenzu-front.sentry.dsn | string | `nil` | Used to populate json config `sentry.dsn` |
| tenzu-front.sentry.environment | string | `nil` | Used to populate json config `sentry.environment`, sentry.release will be set using the image.tag value when docker image is built |
| tenzu-front.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/biru-scop/tenzu-back","tag":"latest"}` | Image to use for the application see: https://kubernetes.io/docs/concepts/containers/images/ |
| tenzu-front.image.tag | string | Uses the .Chart.AppVersion if not set | Overrides the image tag |
| tenzu-front.imagePullSecrets | list | `nil` | List of secrets needed to pull an image from a private repository see: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| tenzu-front.serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | service account properties |
| tenzu-front.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| tenzu-front.serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials |
| tenzu-front.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| tenzu-front.serviceAccount.name | string | If create is true, a name is generated using the fullname template, else it will be set to "default" | The name of the service account to use. |
| tenzu-front.podAnnotations | object | `{}` | Extra annotation to put on frontend Deployment object see: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| tenzu-front.podLabels | object | `{}` | Extra labels to put on frontend Deployment object see: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| tenzu-front.podSecurityContext | object | `{}` | definition of the pod level securityContext on frontend Deployment object |
| tenzu-front.securityContext | object | `{}` | definition of the container level securityContext on frontend Deployment object |
| tenzu-front.service | object | `{"port":80,"type":"ClusterIP"}` | see: https://kubernetes.io/docs/concepts/services-networking/service/ |
| tenzu-front.service.type | string | `"ClusterIP"` | service type defined for the frontend |
| tenzu-front.service.port | int | `80` | service port to access the frontend |
| tenzu-front.ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | properties used to define an Ingress see: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| tenzu-front.ingress.className | string | `""` | will be used to set ingressClassName and "kubernetes.io/ingress.class" annotation depending on k8s version |
| tenzu-front.ingress.annotations | object | Will set kubernetes.io/ingress.class to ingress.className if needed | ingress annotations, can be "kubernetes.io/ingress.class", "kubernetes.io/tls-acme", "cert-manager.io/cluster-issuer", etc. |
| tenzu-front.ingress.hosts | list | `[]` | list of the hosts that will be exposed |
| tenzu-front.ingress.tls | list | `[]` | Expect values in format {secretName: "", hosts: []}, If one of the domain in `ingress.hosts` is also defined as `global.backendUrl.host` You must take care to define tls for it if you also set `global.backendUrl.scheme` to "https" |
| tenzu-front.resources | object | `{}` | container's resources definition set on every jobs and on the frontend Deployment object, If you want to set it, use the following format: `{limits: {cpu: 100m, memory: 128Mi}, requests: cpu: 100m, memory: 128Mi}}` |
| tenzu-front.livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | livenessProbe for the container of the frontend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| tenzu-front.readinessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | readinessProbe for the container of the frontend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| tenzu-front.autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | Whether to define a HorizontalPodAutoscaler with the following scaling properties on cpu and memory consumption see: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| tenzu-front.nodeSelector | object | `{}` | nodeSelector pod property for the frontend Deployment object |
| tenzu-front.tolerations | list | `[]` | tolerations pod property for the frontend Deployment object |
| tenzu-front.affinity | object | `{}` | affinity pod property for the frontend Deployment object |
| tenzu-front.volumes | list | `[]` | Additional volumes for the frontend Deployment object |
| tenzu-front.volumeMounts | list | `[]` | Additional volumeMounts for the frontend Deployment object |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)