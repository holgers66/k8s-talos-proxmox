# tofu/bootstrap/volumes/proxmox-volumes/variables.tf
variable "proxmox_api" {
  type = object({
    endpoint  = string
    insecure  = bool
    api_token = string
  })
  sensitive = true
}

variable "volume" {
  type = object({
    name = string
    node = string
    size = string
    storage = optional(string, "local-lvm")
    vmid = optional(number, 9999)
    format = optional(string, "raw")
  })
}
