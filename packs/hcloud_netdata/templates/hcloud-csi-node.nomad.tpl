job "[[ template "name" . ]]" {

  [[ template "region" . ]]
  datacenters = [[ .hcloud_netdata.datacenters | toStringList ]]
  type        = "system"

  group "netdata" {
    network {
      port "http" {
        to = 19999
      }
    }

    task "app" {
      driver = "docker"

      config {
        image        = "netdata/netdata:[[ .hcloud_netdata.version ]]"
        ports        = [ "http" ]
        security_opt = [ "apparmor:unconfined" ]

        mount {
          type = "bind"
          target = "/host/etc/passwd"
          source = "/etc/passwd"
          readonly = true
          bind_options { propagation = "rshared" }
        }

        mount {
          type = "bind"
          target = "/host/etc/group"
          source = "/etc/group"
          readonly = true
          bind_options { propagation = "rshared" }
        }

        mount {
          type = "bind"
          target = "/host/proc"
          source = "/proc"
          readonly = true
          bind_options { propagation = "rshared" }
        }

        mount {
          type = "bind"
          target = "/host/sys"
          source = "/sys"
          readonly = true
          bind_options { propagation = "rshared" }
        }

        mount {
          type = "bind"
          target = "/host/etc/os-release"
          source = "/etc/os-release"
          readonly = true
          bind_options { propagation = "rshared" }
        }
      }

      resources {
        cpu    = [[ .hcloud_netdata.resources.cpu ]]
        memory = [[ .hcloud_netdata.resources.memory ]]
      }

      service {
        name = "netdata"
        port = "http"

        check {
          type     = "http"
          path     = "/api/v1/info"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}