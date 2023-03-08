job "[[ template "name" . ]]-node" {

  [[ template "region" . ]]
  datacenters = [[ .hcloud_csi_driver.datacenters | toStringList ]]
  type        = "system"

  group "csi-node" {

    task "plugin" {
      driver = "docker"

      config {
        image      = "hetznercloud/hcloud-csi-driver:[[ .hcloud_csi_driver.image_version ]]"
        privileged = true
        command    = "/bin/hcloud-csi-driver-node"
      }

      env {
        CSI_ENDPOINT   = "unix://csi/csi.sock"
      }

      csi_plugin {
        id        = "csi.hetzner.cloud"
        type      = "node"
        mount_dir = "/csi"
      }

      resources {
        cpu    = [[ .hcloud_csi_driver.resources_node.cpu ]]
        memory = [[ .hcloud_csi_driver.resources_node.memory ]]
      }
    }
  }
}