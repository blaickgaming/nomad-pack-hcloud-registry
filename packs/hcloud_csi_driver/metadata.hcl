app {
  url    = "https://github.com/hetznercloud/csi-driver"
  author = "hetznercloud"
}

pack {
  name        = "hcloud_csi_driver"
  description = "This is a Container Storage Interface driver for Hetzner Cloud enabling you to use ReadWriteOnce Volumes within Kubernetes. Please note that this driver requires Kubernetes 1.19 or newer."
  url         = "https://github.com/blaickgaming/nomad-pack-hcloud-registry/hcloud_csi_driver"
  version     = "0.0.1"
}