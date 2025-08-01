# tofu/bootstrap/volumes/proxmox-volumes/proxmox-volume.tf
locals {
  filename = "vm-${var.volume.vmid}-${var.volume.name}"
}

resource "restapi_object" "proxmox-volume" {
  path = "/api2/json/nodes/${var.volume.node}/storage/${var.volume.storage}/content/"

  id_attribute = "data"

  force_new = [var.volume.size]

  data = jsonencode({
    vmid     = var.volume.vmid
    filename = local.filename
    size     = var.volume.size
    format   = var.volume.format
  })

  lifecycle {
    prevent_destroy = true
  }
}

output "node" {
  value = var.volume.node
}

output "storage" {
  value = var.volume.storage
}

output "filename" {
  value = local.filename
}
