variable "name" {
  description = "Name of the Nomad job"
  type        = string
  default     = "hcloud-netdata"
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

variable "version" {
  description = "Docker image this job will use for deployment"
  type        = string
  default     = "latest"
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