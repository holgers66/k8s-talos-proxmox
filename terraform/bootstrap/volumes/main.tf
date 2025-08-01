# tofu/bootstrap/volumes/main.tf
module "proxmox-volume" {
  for_each = var.volumes
  source   = "./proxmox-volume"

  providers = {
    restapi = restapi
  }

  proxmox_api = var.proxmox_api
  volume = {
    name    = each.key
    node    = each.value.node
    size    = each.value.size
    storage = each.value.storage
    vmid    = each.value.vmid
    format  = each.value.format
  }
}

module "persistent-volume" {
  for_each = var.volumes
  source   = "./persistent-volume"

  providers = {
    kubernetes = kubernetes
  }

  volume = {
    name          = each.key
    capacity      = each.value.size
    volume_handle = "${module.proxmox-volume[each.key].node}/${module.proxmox-volume[each.key].storage}/${module.proxmox-volume[each.key].filename}"
    storage       = each.value.storage
  }
}
