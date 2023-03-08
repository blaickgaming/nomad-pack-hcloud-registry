job [[ template "job_name" . ]] {

  [[ template "region" . ]]
  datacenters = [[ .hcloud-csi-controller.datacenters | toStringList ]]
  type        = "service"

  group "hcloud-csi-controller" {

    task "csi-controller" {
      driver = "docker"
      config {
        image      = [[ .hcloud-csi-controller.image | quote ]]
        privileged = true
        command    = "/bin/hcloud-csi-driver-controller"
      }

      template {
        data        = <<-EOH
        CSI_ENDPOINT = "unix://csi/csi.sock"
        HCLOUD_TOKEN = "[[ .hcloud-csi-controller.token | quote ]]"
        EOH
        change_mode = "restart"
        destination = "secret/file.env"
        env         = true
      }

      csi_plugin {
        id        = "csi.hetzner.cloud"
        type      = "controller"
        mount_dir = "/csi"
      }

      resources {
        cpu    = [[ .hcloud-csi-controller.resources.cpu ]]
        memory = [[ .hcloud-csi-controller.resources.memory ]]
      }
    }
  }
}