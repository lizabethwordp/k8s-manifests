{{/*
Expand the name of the chart.
*/}}
{{- define "java-helm-charts.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Determine the branch name from values or infer from .Release.Name
*/}}
{{- define "java-helm-charts.branch" -}}
{{- if .Values.branchName }}
{{- .Values.branchName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- $release := .Release.Name }}
{{- $branch := regexReplaceAll "^" (regexReplaceAll (printf "^%s-?" $name) $release "") "" }}
{{- $branch | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
Result: <nameOverride>-<branch>
*/}}
{{- define "java-helm-charts.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- $branch := include "java-helm-charts.branch" . }}
{{- printf "%s-%s" $name $branch | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "java-helm-charts.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "java-helm-charts.labels" -}}
helm.sh/chart: {{ include "java-helm-charts.chart" . }}
{{ include "java-helm-charts.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "java-helm-charts.selectorLabels" -}}
app.kubernetes.io/name: {{ include "java-helm-charts.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "java-helm-charts.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "java-helm-charts.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
