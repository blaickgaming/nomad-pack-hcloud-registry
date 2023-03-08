# Netdata

This is a Container Storage Interface driver for Hetzner Cloud enabling you to use ReadWriteOnce Volumes within Kubernetes. Please note that this driver requires Kubernetes 1.19 or newer.

## Available Variables

`datacenters` (list of string) - Datacenters this job will be deployed

`image_version` (string) - Redis Docker image.

`name` (string) - Name of the Nomad job

`token` (string) - Hetzner API Token used for deployment

`region` (string) - Region where the job should be placed.

`resources_controller` (object) - Resources to assign this job

`resources_node` (object) - Resources to assign this job