job "[[ template "name" . ]]-controller" {

  [[ template "region" . ]]
  datacenters = [[ .hcloud_csi_driver.datacenters | toStringList ]]
  type        = "service"

  group "csi-controller" {

    task "plugin" {
      driver = "docker"
      config {
        image      = "hetznercloud/hcloud-csi-driver:[[ .hcloud_csi_driver.image_version ]]"
        privileged = true
        command    = "/bin/hcloud-csi-driver-controller"
      }

      template {
        data        = <<-EOH
        CSI_ENDPOINT = "unix://csi/csi.sock"
        HCLOUD_TOKEN = [[ .hcloud_csi_driver.token | quote ]]
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
        cpu    = [[ .hcloud_csi_driver.resources_controller.cpu ]]
        memory = [[ .hcloud_csi_driver.resources_controller.memory ]]
      }
    }
  }
}