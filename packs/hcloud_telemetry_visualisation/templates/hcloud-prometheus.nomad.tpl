job "[[ template "name" . ]]-prometheus" {
  
  [[ template "region" . ]]
  datacenters = [[ .hcloud_csi_driver.datacenters | toStringList ]]
  
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }  

  group "prometheus" {

    network {
      mode = "bridge"
      port "http" {
        to = 9090
      }
    }

    task "app" {
      driver = "docker"

      config {
        image  = "prom/prometheus:v2.33.1"
        ports  = ["http"]
        args   = [
          "--config.file=/etc/prometheus/config/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.listen-address=0.0.0.0:9090",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles"
        ]
        volumes = [
          "local/config:/etc/prometheus/config",
        ]
      }
      template {
        data = <<-EOH
        ---
        global:
          scrape_interval: 30s
          evaluation_interval: 3s
          
        rule_files:
        - rules.yml
        
        alerting:
          alertmanagers:
          - consul_sd_configs:
            - server: {{ env "attr.unique.network.ip-address" }}:8500
              services: ["alertmanager"]
              
        scrape_configs:
        - job_name: prometheus
          static_configs:
          - targets: ["0.0.0.0:9090"]

        - job_name: "docker"
          static_configs:
          - targets: ["{{ env "attr.unique.network.ip-address" }}:9323"]

        - job_name: "cadvisor"
          consul_sd_configs:
          - server: "{{ env "attr.unique.network.ip-address" }}:8500"
            services: ["cadvisor"]

        - job_name: "nomad_server"
          metrics_path: "/v1/metrics"
          params:
            format: ["prometheus"]
          consul_sd_configs:
          - server: "{{ env "attr.unique.network.ip-address" }}:8500"
            services: ["nomad"]
            tags: ["http"]

        - job_name: "nomad_client"
          metrics_path: "/v1/metrics"
          params:
            format: ["prometheus"]
          consul_sd_configs:
          - server: "{{ env "attr.unique.network.ip-address" }}:8500"
            services: ["nomad-client"]

        - job_name: "traefik"
          consul_sd_configs:
          - server: "{{ env "attr.unique.network.ip-address" }}:8500"
            services: ["traefik"]
        EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/prometheus.yml"
      }

      resources {
        cpu    = [[ .hcloud_telemetry_visualisation.resources_prometheus.cpu ]]
        memory = [[ .hcloud_telemetry_visualisation.resources_prometheus.memory ]]
      }

      service {
        name = "prometheus"
        port = "http"

        check {
          type     = "http"
          path     = "/-/healthy"
          interval = "3s"
          timeout  = "1s"
        }
      }
    }
  }
}
