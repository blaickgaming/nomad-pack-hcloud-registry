variable "name" {
  description = "Name of the Nomad job"
  type        = string
  default     = "hcloud-csi"
}

variable "datacenters" {
  description = "Datacenters this job will be deployed"
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "Region where the job should be placed."
  type        = string
  default     = "global"
}

variable "resources_grafana" {
  description = "Resources to assign this job"
  type        = object({
    cpu       = number
    memory    = number
  })
  default     = {
    cpu       = 100,
    memory    = 256
  }
}

variable "grafana_host_address" {
  description = "."
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "Password used for the admin user created in Grafana."
  type        = string
  default     = "global"
}

variable "resources_prometheus" {
  description = "Resources to assign this job"
  type        = object({
    cpu       = number
    memory    = number
  })
  default     = {
    cpu       = 200,
    memory    = 256
  }
}