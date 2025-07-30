# tofu/bootstrap/volumes/variables.tf
variable "proxmox_api" {
  type = object({
    endpoint     = string
    insecure     = bool
    api_token    = string
  })
  sensitive = true
}

variable "volumes" {
  type = map(
    object({
      node = string
      size = string
      storage = optional(string, "local-lvm")
      vmid = optional(number, 9999)
      format = optional(string, "raw")
    })
  )
}
