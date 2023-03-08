job "[[ template "name" . ]]-grafana" {
  
  [[ template "region" . ]]
  datacenters = [[ .hcloud_telemetry_visualisation.datacenters | toStringList ]]
  type        = "system"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "grafana" {

    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "grafana/grafana:latest"
        ports = ["http"]
      }

      template {
        data        = <<-EOH
        GF_LOG_LEVEL = "DEBUG"
        GF_LOG_MODE = "console"
        GF_SERVER_HTTP_PORT = "{{ env "NOMAD_PORT_http" }}"
        GF_PATHS_PROVISIONING = "/local/grafana/provisioning"
        GF_SECURITY_ADMIN_PASSWORD = [[ .hcloud_telemetry_visualisation.admin_password | quote  ]]
        EOH
        change_mode = "restart"
        destination = "secret/file.env"
        env         = true
      }

      artifact {
        source      = "https://grafana.com/api/dashboards/1860/revisions/26/download"
        destination = "local/grafana/provisioning/dashboards/linux/linux-node-exporter.json"
        mode = "file"
      }

      template {
        data = <<-EOF
        apiVersion: 1
        providers:
        - name: dashboards
          type: file
          updateIntervalSeconds: 30
          options:
            foldersFromFilesStructure: true
            path: /local/grafana/provisioning/dashboards
        EOF
        destination = "/local/grafana/provisioning/dashboards/dashboards.yaml"
      }

      template {
        data = <<-EOF
        apiVersion: 1
        datasources:
        {{- range service "prometheus" }}
        - name: "{{ .Name }}"
          type: prometheus
          access: proxy
          url: "http://{{ .Address }}:{{ .Port }}"
        {{- end }}
        {{- range service "loki" }}
        - name: "{{ .Name }}"
          type: loki
          access: proxy
          url: "http://{{ .Address }}:{{ .Port }}"
        {{- end }}
        EOF
        change_mode = "restart"
        destination = "/local/grafana/provisioning/datasources/datasources.yaml"
      }

      resources {
        cpu    = [[ .hcloud_telemetry_visualisation.resources_grafana.cpu ]]
        memory = [[ .hcloud_telemetry_visualisation.resources_grafana.memory ]]
      }

      service {
        name = "grafana"
        port = "http"
        tags = [
          [[ template "grafana_host_address" . ]]
        ]

        check {
          type     = "http"
          path     = "/api/health"
          interval = "5s"
          timeout  = "1s"
        }
      }
    }
  }
}