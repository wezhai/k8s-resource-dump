apiVersion: {{.apiVersion}}
kind: Service
metadata:
  {{- with .metadata }}
  name: {{ .name }}
  namespace: {{ .namespace }}
  labels:
    {{- range $key, $value := .labels }}
    {{ $key }}: {{ $value }} 
    {{- end }}
  {{- end }}
spec:
  {{- with .spec }}
  type: {{ .type }}
  {{- if eq .type "ExternalName" }}
  externalName: {{ .externalName }}
  {{- end }}
  ports: 
  {{- range .ports }}
  - port: {{ .port }}
    {{- range $key, $value := . }}
    {{- if ne $key "port" }}
    {{ $key }}: {{ $value }}
    {{- end }}
    {{- end }}
    {{- if .nodePort }}
    nodePort: {{ .nodePort }}
    {{- end }}
  {{- end }}

  {{- with .selector}}
  selector:
    {{- range $key, $value := . }}
    {{ $key }}: {{ $value }}
    {{- end }}
  {{- end }}
  {{- end }}
