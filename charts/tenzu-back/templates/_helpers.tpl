{{/*
Expand the name of the chart.
*/}}
{{- define "tenzu-back.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tenzu-back.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tenzu-back.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tenzu-back.labels" -}}
helm.sh/chart: {{ include "tenzu-back.chart" . }}
{{ include "tenzu-back.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tenzu-back.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tenzu-back.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Job annotations
*/}}
{{- define "tenzu-back.jobAnnotations" -}}
"helm.sh/hook": post-install, post-upgrade
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end }}

{{/*
Secret dependencies annotations
*/}}
{{- define "tenzu-back.secretDependenciesAnnotations" -}}
checksum/secret: {{ include (print $.Template.BasePath "/secrets.yaml") . | sha256sum }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "tenzu-back.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tenzu-back.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Caddy labels
*/}}
{{- define "tenzu-back.caddyLabels" -}}
app.kubernetes.io/name: {{ include "tenzu-back.name" . }}-caddy
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
worker labels
*/}}
{{- define "tenzu-back.workerLabels" -}}
app.kubernetes.io/name: {{ include "tenzu-back.name" . }}-worker
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the sentry env variable
*/}}
{{- define "tenzu-back.sentryEnvValues" -}}
{{- if .Values.sentry.enabled -}}
- name: SENTRY_DSN
  value: {{ .Values.sentry.dsn }}
- name: SENTRY_ENVIRONMENT
  value: {{ .Values.sentry.environment }}
- name: SENTRY_RELEASE
  value: {{ .Values.image.tag }}
{{- end }}
{{- end }}

{{/*
Create the redis env variable that need to be put into a secret
*/}}
{{- define "tenzu-back.redisSecretEnvValues" -}}
{{- if .Values.redis.password }}
- name: TENZU_EVENTS__REDIS_PASSWORD
  value: {{ .Values.redis.password }}
{{- end }}
{{- end }}

{{/*
Create the redis env variable that can be included directly
*/}}
{{- define "tenzu-back.redisEnvValues" -}}
{{- if .Values.redis.existingSecret }}
- name: TENZU_EVENTS__REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.existingSecret }}
      key: {{ required " " .Values.redis.passwordKey }}
{{- end }}
- name: TENZU_EVENTS__REDIS_HOST
  value: {{ required "A host is mandatory for redis " .Values.redis.host }}
- name: TENZU_EVENTS__REDIS_OPTIONS
  value: {{ .Values.redis.options | quote }}
{{- end }}


{{/*
Create the postgresql env variable that need to be put into a secret
*/}}
{{- define "tenzu-back.postgresqlSecretEnvValues" -}}
{{- if .Values.postgresql.auth.password }}
- name: TENZU_DB__PASSWORD
  value: {{ .Values.postgresql.auth.password }}
{{- end }}
{{- if .Values.postgresql.auth.database }}
- name: TENZU_DB__NAME
  value: {{ .Values.postgresql.auth.database }}
{{- end }}
{{- if .Values.postgresql.auth.username }}
- name: TENZU_DB__USER
  value: {{ .Values.postgresql.auth.username }}
{{- end }}
{{- end }}

{{/*
Create the postgresql env variable that can be included directly
*/}}
{{- define "tenzu-back.postgresqlEnvValues" -}}
{{- if .Values.postgresql.auth.existingSecret -}}
{{- if .Values.postgresql.auth.passwordKey }}
- name: TENZU_DB__PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.auth.passwordKey }}
{{- end }}
{{- if .Values.postgresql.auth.databaseKey }}
- name: TENZU_DB__NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.auth.databaseKey }}
{{- end }}
{{- if .Values.postgresql.auth.usernameKey }}
- name: TENZU_DB__USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.auth.usernameKey }}
{{- end }}
{{- end }}
- name: TENZU_DB__HOST
  value: {{ required "A password is mandatory for postgresql" .Values.postgresql.host }}
{{- end }}


{{/*
Create the email env variable
*/}}
{{- define "tenzu-back.emailEnvValues" -}}
- name: TENZU_SUPPORT_EMAIL
  value: {{ .Values.email.supportEmail }}
- name: TENZU_EMAIL__EMAIL_BACKEND
  value: "django.core.mail.backends.smtp.EmailBackend"
- name: TENZU_EMAIL__DEFAULT_FROM_EMAIL
  value: {{ required "A default from email is mandatory" .Values.email.defaultFrom }}
- name: TENZU_EMAIL__EMAIL_HOST
  value: {{ required "An email host is mandatory" .Values.email.host }}
- name: TENZU_EMAIL__EMAIL_PORT
  value: {{ .Values.email.port | quote }}
- name: TENZU_EMAIL__EMAIL_HOST_USER
  value: {{ required "An email host user is mandatory" .Values.email.user }}
- name: TENZU_EMAIL__EMAIL_HOST_PASSWORD
  value: {{ required "An email host password is mandatory" .Values.email.password }}
- name: TENZU_EMAIL__EMAIL_USE_TLS
  value: {{ .Values.email.tls | quote}}
- name: TENZU_EMAIL__EMAIL_USE_SSL
  value: {{ .Values.email.ssl | quote }}
{{- end }}

{{/*
Create the s3 env variable
*/}}
{{- define "tenzu-back.s3EnvValues" -}}
{{- if .Values.s3.enable }}
- name: TENZU_STORAGE__BACKEND_CLASS
  value: "storages.backends.s3.S3Storage"
{{- if .Values.s3.existingSecret.bucketNameKey }}
- name: TENZU_STORAGE__AWS_STORAGE_BUCKET_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.s3.existingSecret.name }}
      key: {{ .Values.s3.existingSecret.bucketNameKey }}
{{- else }}
- name: TENZU_STORAGE__AWS_STORAGE_BUCKET_NAME
  value: {{ .Values.s3.bucketName }}
{{- end }}
{{- if .Values.s3.existingSecret.secretAccessKeyKey}}
- name: TENZU_STORAGE__AWS_S3_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.s3.existingSecret.name }}
      key: {{ .Values.s3.existingSecret.secretAccessKeyKey }}
{{- else }}
- name: TENZU_STORAGE__AWS_S3_SECRET_ACCESS_KEY
  value: {{ .Values.s3.secretAccessKey }}
{{- end}}
{{- if .Values.s3.existingSecret.accessKeyKey }}
- name: TENZU_STORAGE__AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Values.s3.existingSecret.name }}
      key: {{ .Values.s3.existingSecret.accessKeyKey }}
{{- else }}
- name: TENZU_STORAGE__AWS_ACCESS_KEY_ID
  value: {{ .Values.s3.accessKey }}
{{- end }}
{{- if .Values.s3.existingSecret.endpointUrlKey }}
- name: TENZU_STORAGE__AWS_S3_ENDPOINT_URL
  valueFrom:
    secretKeyRef:
      name: {{ .Values.s3.existingSecret.name }}
      key: {{ .Values.s3.existingSecret.endpointUrlKey }}
{{- else }}
- name: TENZU_STORAGE__AWS_S3_ENDPOINT_URL
  value: {{ .Values.s3.endpointUrl }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Define the secrets keys
*/}}
{{- define "tenzu-back.secretKeys" -}}
- name: TENZU_SECRET_KEY
  value: {{ required "a .secretKey is required" .Values.secretKey | quote }}
- name: TENZU_TOKENS__SIGNING_KEY
  value: {{ required "a .tokensSigningKey is required" .Values.tokenSigningKey | quote }}
{{- end }}


{{/*
Define the frontend and backend url
*/}}
{{- define "tenzu-back.urls" -}}
- name: TENZU_BACKEND_URL
  value: {{ printf "%s://%s" .Values.global.backendUrl.scheme .Values.global.backendUrl.host }}
- name: TENZU_FRONTEND_URL
  value: {{ printf "%s://%s" .Values.global.frontendUrl.scheme .Values.global.frontendUrl.host }}
{{- end }}
