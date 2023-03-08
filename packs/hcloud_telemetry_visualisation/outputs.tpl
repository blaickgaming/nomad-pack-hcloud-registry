Congratulations on deploying [[ .nomad_pack.pack.name ]]! 

[[- if not (eq .hcloud_telemetry_visualisation.grafana_host_address "") -]]
Use the provided address https://[[ .hcloud_telemetry_visualisation.grafana_host_address ]] to access Grafana.
[[- end -]]

Navigate to the HashiCups UI on port [[ .hashicups.nginx_port ]] of the Nomad client running the job.