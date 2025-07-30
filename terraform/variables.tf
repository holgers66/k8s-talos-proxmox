# tofu/variables.tf
variable "proxmox" {
  type = object({
    name         = string
    endpoint     = string
    insecure     = bool
    username     = string
    api_token    = string
  })
  sensitive = true
}
