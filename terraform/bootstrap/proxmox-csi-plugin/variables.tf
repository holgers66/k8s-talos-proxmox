# tofu/bootstrap/proxmox-csi-plugin/variables.tf
variable "proxmox" {
  type = object({
    endpoint = string
    insecure = bool
  })
}
