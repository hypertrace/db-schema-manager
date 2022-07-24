# db-schema-manager
Helm chart for managing database schema using [liquibase](https://www.liquibase.org/). This helm chart is designed to be used as a sub-chart of main application helm chart.

## Usage
Make the following changes in the application helm chart:

1. Add this chart to the dependencies list of the application chart:
   ```yaml
    dependencies:
      - name: db-schema-manager
        repository: https://storage.googleapis.com/hypertrace-helm-charts
        version: 0.1.1
        condition: db-schema-manager.enabled
   ```

2. Create a folder named `schemas` outside the `templates` folder in helm chart and add liquibase changelogs files. For more information on changelogs, please refer to https://docs.liquibase.com/concepts/changelogs/working-with-changelogs.html.

3. Create a new file in `templates` folder with the following content:
   ```
   {{- if (index .Values "db-schema-manager" "enabled") }}
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: {{ index .Values "db-schema-manager" "jobName" }}
     labels:
       app: {{ index .Values "db-schema-manager" "jobName" }}
       release: {{ .Release.Name }}
     annotations:
       {{- toYaml (index .Values "db-schema-manager" "annotations") | nindent 4 }}
   data:
   {{- $files := .Files }}
   {{- range $path, $bytes := .Files.Glob "schemas/*" }}
   {{ base $path | indent 2 }}: |
   {{ tpl ($files.Get $path) $ | indent 4 }}
   {{- end }}
   {{- end }}
   ```
   This will create a ConfigMap using the content of files in `schemas` folder. This ConfigMap will be mounted into the pod so that liquibase can access them to upgrade the database schema.

4. Update the `values.yaml` file:
   ```yaml
   db-schema-manager:
     enabled: true
     jobName: "service-name-db-schema-manager"
     changeLogFile: "/etc/liquibase/changelogs/changelog.sql"
     database:
       url: "jdbc:postgresql://postgresql:5432/hypertrace"
       username: "hypertrace"
       passwordSecretName: "postgresql-postgresql"
       passwordSecretKey: "postgresql-password"
   ```  
