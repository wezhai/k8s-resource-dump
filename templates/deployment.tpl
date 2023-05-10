kind: {{ .kind }}
apiVersion: {{ .apiVersion }}
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
    {{- with .replicas }}
  replicas: {{ . }}
    {{- end }}
  selector:
    matchLabels:  
      {{- range $key, $value := .selector.matchLabels }}
      {{ $key }}: {{ $value }}
      {{- end }}
  {{- with .template }}
  template:    
    metadata:
      labels: 
        {{- range $key, $value := .metadata.labels }}
        {{ $key }}: {{ $value }}
        {{- end }}
    {{- with .spec }}
    spec: 
      {{- with .containers }}
      containers:
        {{- range . }}
        - name: {{ .name }}
          image: {{ .image }} 
          {{- with .ports }}
          ports:
            {{- range . }}
            - containerPort: {{ .containerPort }}
              {{- range $key, $value := . }} 
              {{- if ne $key "containerPort" }}
              {{ $key }}: {{ $value }}
              {{- end }}
              {{- end }}
            {{- end }}
          {{- end }} 
          {{- with .env }}
          env:
            {{- range . }}
            - name: {{ .name }}
              value: {{ .value }}
            {{- end }}
          {{- end }}
          {{- with .resources }}
          resources:
            {{- range $key, $value := . }}
            {{ $key }}: {{ $value }}
            {{- end }}
          {{- end }}
          {{- with .terminationMessagePath }}
          terminationMessagePath: {{ . }}
          {{- end }}
          {{- with .terminationMessagePolicy }}
          terminationMessagePolicy: {{ . }}
          {{- end }}
          imagePullPolicy: {{ .imagePullPolicy }}
        {{- end }}
      {{- end }}
      {{- with .restartPolicy }}
      restartPolicy: {{ . }}
      {{- end }}
      {{- with .terminationGracePeriodSeconds }}
      terminationGracePeriodSeconds: {{ . }}
      {{- end }}
      {{- with .dnsPolicy }}
      dnsPolicy: {{ . }}
      {{- end }}
      {{- with .hostAliases }}
      hostAliases:
      {{- range . }}
      - hostnames:
        {{- range .hostnames }}
        - {{ . }}
        {{- end }}
        ip: {{ .ip }}
      {{- end }}
      {{- end }}
      {{- with .serviceAccountName }}
      serviceAccountName: {{ . }}
      {{- end }}
      {{- with .serviceAccount }}
      serviceAccount: {{ . }}
      {{- end }}
      {{- with .securityContext }}
      securityContext:
        {{- range $key, $value := . }}
        {{ $key }}: {{ $value }}
        {{- end }}
      {{- end }}
      {{- with .imagePullSecrets }}
      imagePullSecrets:
        {{- range . }}
        - name: {{ .name }}
        {{- end }}
      {{- end }}
      schedulerName: {{ .schedulerName }}
    {{- end }}
  {{- end }}
  {{- with .strategy }}
  strategy:
    type: {{ .type }}
    {{- if eq .type "RollingUpdate" }}
    rollingUpdate:
      {{- range $key, $value := .rollingUpdate }}
      {{ $key }}: {{ $value }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- with .minReadySeconds }}
  minReadySeconds: {{ . }}
  {{- end }}
  {{- with .revisionHistoryLimit }}
  revisionHistoryLimit: {{ . }}
  {{- end }}
  {{- with .progressDeadlineSeconds }}
  progressDeadlineSeconds: {{ . }}
  {{- end }}
{{- end }}
