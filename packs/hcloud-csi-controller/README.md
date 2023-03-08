# Container Storage Interface driver for Hetzner Cloud

This is a Container Storage Interface driver for Hetzner Cloud enabling you to use ReadWriteOnce Volumes within Kubernetes. Please note that this driver requires Kubernetes 1.19 or newer.

## Available Variables

`datacenters` (list of string) - Datacenters this job will be deployed

`image` (string) - Redis Docker image.

`name` (string) - Name of the Nomad job

`token` (string) - Hetzner API Token used for deployment

`region` (string) - Region where the job should be placed.

`resources` (object) - Resources to assign this job