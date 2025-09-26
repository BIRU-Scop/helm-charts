# tenzu-back

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart to run the API webservices backend and task queue worker of Tenzu

**Homepage:** <https://tenzu.net/docs>

## Values

> [!IMPORTANT]
> A lot of the the values are described as being used to populate some environment variables,
> you can find the description of those variables in the [documentation](https://tenzu.net/docs/configuration#configure-tenzu-backend)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | will use .Chart.Name | Used by name template: to fill the app.kubernetes.io/name label |
| fullnameOverride | string | will use .Release.Name suffixed with name template, if .Release.Name does not already contains it | Used by fullname template: to fill the name of all created kubernetes component |
| replicaCount | int | `1` | number of pod replicas for the api backend and the worker service if not using autoscaling see: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| caddy.replicas | int | `1` |  |
| granian | bool | `false` | choice true: granian, false gunicorn |
| workersQuantity | int | `1` | number workers started by the server |
| workersTimeout | int | `120` | timeout of workers used by the server |
| logLevel | string | `"warning"` | level of log produced by the server |
| sentry.enabled | bool | `false` | Whether to set the environment variable expected by the error tracker |
| sentry.dsn | string | `nil` | Used to populate SENTRY_DSN |
| sentry.environment | string | `nil` | Used to populate SENTRY_ENVIRONMENT, SENTRY_RELEASE will be set using the image.tag value |
| secretKey | string | `nil` | Used to populate `TENZU_SECRET_KEY` |
| tokenSigningKey | string | `nil` | Used to populate `TENZU_TOKENS__SIGNING_KEY` |
| env | list | `[]` | additionnal environment variable to set on every jobs and on the backend and task queue Deployment objects. |
| envFrom | list | `[]` | additionnal environment variable to set on every jobs and on the backend and task queue Deployment objects, fetched from a secret or config map |
| email.tls | bool | `true` | Used to populate `TENZU_EMAIL__EMAIL_USE_TLS` |
| email.ssl | bool | `false` | Used to populate `TENZU_EMAIL__EMAIL_USE_SSL` |
| email.port | int | `547` | Used to populate `TENZU_EMAIL__EMAIL_PORT` |
| email.defaultFrom | string | `nil` | Used to populate `TENZU_EMAIL__DEFAULT_FROM_EMAIL` |
| email.host | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST` |
| email.user | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST_USER` |
| email.password | string | `nil` | Used to populate `TENZU_EMAIL__EMAIL_HOST_PASSWORD` |
| email.supportEmail | string | `nil` | Used to populate `TENZU_SUPPORT_EMAIL` |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/biru-scop/tenzu-back","tag":"latest"}` | Image to use for the application see: https://kubernetes.io/docs/concepts/containers/images/ |
| image.tag | string | `"latest"` | Overrides the image tag |
| imagePullSecrets | list | `nil` | List of secrets needed to pull an image from a private repository see: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | service account properties |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | If create is true, a name is generated using the fullname template, else it will be set to "default" | The name of the service account to use. |
| podAnnotations | object | `{}` | Extra annotation to put on backend and task queue Deployment objects see: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | Extra labels to put on backend and task queue Deployment objects see: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{}` | definition of the pod level securityContext on backend and task queue Deployment objects |
| securityContext | object | `{}` | definition of the container level securityContext on backend and task queue Deployment objects |
| service | object | `{"port":8000,"type":"ClusterIP"}` | see: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.type | string | `"ClusterIP"` | service type defined for the backend and the reverse proxy |
| service.port | int | `8000` | service port to access the backend |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | properties used to define an Ingress see: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| ingress.className | string | `""` | will be used to set ingressClassName and "kubernetes.io/ingress.class" annotation depending on k8s version |
| ingress.annotations | object | Will set kubernetes.io/ingress.class to ingress.className if needed | ingress annotations, can be "kubernetes.io/ingress.class", "kubernetes.io/tls-acme", "cert-manager.io/cluster-issuer", etc. |
| ingress.hosts | list | `[]` | list of the hosts that will be exposed |
| ingress.tls | list | `[]` | Expect values in format {secretName: "", hosts: []}, If one of the domain in `ingress.hosts` is also defined as `global.backendUrl/frontendUrl.host` You must take care to define tls for it if you also set `global.backendUrl/frontendUrl.scheme` to "https" |
| resources | object | `{}` | container's resources definition set on every jobs and on the backend and task queue Deployment objects, If you want to set it, use the following format: `{limits: {cpu: 100m, memory: 128Mi}, requests: cpu: 100m, memory: 128Mi}}` |
| livenessProbe | object | `{"httpGet":{"path":"/api/v1/healthcheck","port":8000}}` | livenessProbe for the container of the backend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| readinessProbe | object | `{"httpGet":{"path":"/api/v1/healthcheck","port":8000}}` | readinessProbe for the container of the backend service see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | Whether to define a HorizontalPodAutoscaler with the following scaling properties on cpu and memory consumption see: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| nodeSelector | object | `{}` | nodeSelector pod property for the backend and task queue Deployment objects |
| tolerations | list | `[]` | tolerations pod property for the backend and task queue Deployment objects |
| affinity | object | `{}` | affinity pod property for the backend and task queue Deployment objects |
| cronJobs | list | `[]` | list of object in format {name: string, schedule: string, command: string[]} schedule and command should be set to the format expected by CronJob (see: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) |
| persistentVolumeClaim.media | object | `{"accessModes":["ReadWriteMany"],"resources":{"requests":{"storage":"10Gi"}}}` | Spec of the PersistentVolumeClaim used by the volume for media files |
| persistentVolumeClaim.media.resources.requests.storage | string | `"10Gi"` | Storage size for the PersistentVolumeClaim used by the volume for media files, change the capacity to what you need |
| postgresql.auth | object | `{"database":null,"databaseKey":null,"existingSecret":null,"password":null,"passwordKey":null,"username":null,"usernameKey":null}` | To configure the postgresql connexion you can use an existing secret, direct values or a mix of both Only use one method for each expected value |
| postgresql.auth.existingSecret | string | `nil` | existing secret where all necessary value can be found |
| postgresql.auth.passwordKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__PASSWORD` |
| postgresql.auth.databaseKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__NAME` |
| postgresql.auth.usernameKey | string | `nil` | key to access value in existingSecret, used to populate `TENZU_DB__USER` |
| postgresql.auth.password | string | `nil` | password value, used to populate `TENZU_DB__PASSWORD` |
| postgresql.auth.database | string | `nil` | database name value, used to populate `TENZU_DB__NAME` |
| postgresql.auth.username | string | `nil` | username value, used to populate `TENZU_DB__USER` |
| postgresql.host | string | `nil` | Used to populate `TENZU_DB__HOST` It can be something like tenzu-postgres.$NAMESPACE.svc.cluster.local |
| redis | object | `{"existingSecret":null,"host":null,"options":"{\"health_check_interval\": 5}","password":null,"passwordKey":null}` | Specify redis configuration, password can be given directly or through a secret |
| redis.options | string | `"{\"health_check_interval\": 5}"` | Used to populate `TENZU_EVENTS__REDIS_OPTIONS` |
| redis.host | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_HOST` It can be something like "tenzu-redis-headless.$NAMESPACE.svc.cluster.local" |
| redis.password | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` using the passed value directly |
| redis.existingSecret | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` If you want to use an existing secret for the password instead |
| redis.passwordKey | string | `nil` | Used to populate `TENZU_EVENTS__REDIS_PASSWORD` If you use redis.existingSecret, you must set this key to the corresponding value to use in the secret |
| s3 | object | `{"accessKey":null,"bucketName":null,"enable":false,"endpointUrl":null,"existingSecret":{"accessKeyKey":null,"bucketNameKey":null,"endpointUrlKey":null,"name":null,"secretAccessKeyKey":null},"secretAccessKey":null}` | Specify s3 configuration, configuration can be given directly or through a secret |
| s3.enable | bool | `false` | enable`the s3; if enabled, you must set up all of endpointUrl, accessKey, secretAccessKey, bucketName either directly or through s3.existingSecret |
| s3.endpointUrl | string | `nil` | Used to populate `TENZU_STORAGE__AWS_S3_ENDPOINT_URL` |
| s3.accessKey | string | `nil` | Used to populate `TENZU_STORAGE__AWS_ACCESS_KEY_ID` |
| s3.secretAccessKey | string | `nil` | Used to populate `TENZU_STORAGE__AWS_S3_SECRET_ACCESS_KEY` |
| s3.bucketName | string | `nil` | Used to populate `TENZU_STORAGE__AWS_STORAGE_BUCKET_NAME` |
| s3.existingSecret | object | `{"accessKeyKey":null,"bucketNameKey":null,"endpointUrlKey":null,"name":null,"secretAccessKeyKey":null}` | Specify s3 configuration through an existing secret |
| s3.existingSecret.name | string | `nil` | The secret name containing the s3 configuration. **required** if any one of `s3.existingSecret.\*Key` are set |
| s3.existingSecret.endpointUrlKey | string | `nil` | Fetch from secret instead of setting `s3.endpointUrl` |
| s3.existingSecret.accessKeyKey | string | `nil` | Fetch from secret instead of setting `s3.accessKey` |
| s3.existingSecret.secretAccessKeyKey | string | `nil` | Fetch from secret instead of setting `s3.secretAccessKey` |
| s3.existingSecret.bucketNameKey | string | `nil` | Fetch from secret instead of setting `s3.bucketName` |
| global | object | `{"backendUrl":{"host":null,"scheme":"https"},"frontendUrl":{"host":null,"scheme":"https"},"maxUploadFileSize":"104857600"}` | global values to share properties among charts. |
| global.backendUrl | object | `{"host":null,"scheme":"https"}` | url used to serve the backend, will be used to set `TENZU_BACKEND_URL` If exposed via ingress, host should be the same as the ingress' and scheme must be coherent with ingress' tls |
| global.maxUploadFileSize | int or "null" | `"104857600"` | maximum size, in bytes, for uploaded files. Set to "null" for no limit. You may need to adapt the ingress configuration to support big uploads |
| global.frontendUrl | object | `{"host":null,"scheme":"https"}` | url used to serve the frontend, will be used to set `TENZU_FRONTEND_URL` If exposed via ingress, host should be the same as the ingress' and scheme must be coherent with ingress' tls |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)