[[- define "name" -]]
[[- if eq .hcloud_telemetry_visualisation.name "" -]]
[[- .nomad_pack.pack.name -]]
[[- else -]]
[[- .hcloud_telemetry_visualisation.name -]]
[[- end -]]
[[- end -]]

[[- define "region" -]]
[[- if not (eq .hcloud_telemetry_visualisation.region "") -]]
region = [[ .hcloud_telemetry_visualisation.region | quote ]]
[[- end -]]
[[- end -]]

[[- define "grafana_host_address" -]]
[[- if not (eq .hcloud_telemetry_visualisation.grafana_host_address "") -]]
"traefik.enable=true",
"traefik.http.routers.[[ template "name" . ]]-grafana.rule=Host(`[[- .hcloud_telemetry_visualisation.grafana_host_address -]]`)",
"traefik.http.routers.[[ template "name" . ]]-grafana.tls=true",
"traefik.http.routers.[[ template "name" . ]]-grafana.tls.certresolver=lets-encrypt"
[[- end -]]
[[- end -]]