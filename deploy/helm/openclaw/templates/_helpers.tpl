{{/*
Resource name: <userId>-openclaw
*/}}
{{- define "openclaw.name" -}}
{{- printf "%s-openclaw" .Values.userId -}}
{{- end -}}

{{/*
PVC name
*/}}
{{- define "openclaw.pvcName" -}}
{{- printf "%s-openclaw-data" .Values.userId -}}
{{- end -}}

{{/*
FQDN for this user instance
*/}}
{{- define "openclaw.host" -}}
{{- printf "%s.%s" .Values.userId .Values.domain.base -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "openclaw.labels" -}}
app.kubernetes.io/name: openclaw
app.kubernetes.io/instance: {{ .Values.userId }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
openclaw.ai/user: {{ .Values.userId }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "openclaw.selectorLabels" -}}
app.kubernetes.io/name: openclaw
app.kubernetes.io/instance: {{ .Values.userId }}
{{- end -}}
