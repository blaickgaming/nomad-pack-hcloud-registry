variable "name" {
  description = "Name of the Nomad job"
  type        = string
  default     = "hcloud-csi-controller"
}

variable "token" {
  description = "Hetzner API Token used for deployment"
  type        = string
  default     = ""
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

variable "image" {
  description = "Docker image this job will use for deployment"
  type        = string
  default     = "hetznercloud/hcloud-csi-driver:2.0.0"
}

variable "resources" {
  description = "Resources to assign this job"
  type        = object({
    cpu       = number
    memory    = number
  })
  default     = {
    cpu       = 100,
    memory    = 64
  }
}