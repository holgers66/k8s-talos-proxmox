# tofu/main.tf
module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  image = {
    version = "v1.7.5"
    schematic = file("${path.module}/talos/image/schematic.yaml")
  }

  cilium = {
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
    values = file("${path.module}/../kubernetes/cilium/values.yaml")
  }

  cluster = {
    name            = "k8s-demo"
    endpoint        = "192.168.178.240"
    gateway         = "192.168.178.1"
    talos_version   = "v1.7"
  }

  nodes = {
    "ctrl-00" = {
      machine_type  = "controlplane"
      ip            = "192.168.178.240"
      mac_address   = "BC:24:11:2E:C8:00"
      vm_id         = 800
      cpu           = 8
      ram_dedicated = 4096
      host_node     = "pve"
    }
    "work-00" = {
      machine_type  = "worker"
      ip            = "192.168.178.250"
      mac_address   = "BC:24:11:2E:08:00"
      vm_id         = 810
      cpu           = 4
      ram_dedicated = 4096
      host_node     = "pve"
    }
    "work-01" = {
      machine_type  = "worker"
      ip            = "192.168.178.251"
      mac_address   = "BC:24:11:2E:08:01"
      vm_id         = 811
      cpu           = 4
      ram_dedicated = 4096
      host_node     = "pve"
    }
    "work-02" = {
      machine_type  = "worker"
      ip            = "192.168.178.252"
      mac_address   = "BC:24:11:2E:08:02"
      vm_id         = 812
      cpu           = 8
      ram_dedicated = 4096
      host_node     = "pve"
    }
  }
}

module "sealed_secrets" {
  depends_on = [module.talos]
  source = "./bootstrap/sealed-secrets"

  providers = {
    kubernetes = kubernetes
  }

  cert = {
    cert = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.cert")
    key = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.key")
  }
}

module "proxmox_csi_plugin" {
  depends_on = [module.talos]
  source = "./bootstrap/proxmox-csi-plugin"

  providers = {
    proxmox    = proxmox
    kubernetes = kubernetes
  }

  proxmox = var.proxmox
}

module "volumes" {
  depends_on = [module.proxmox_csi_plugin]
  source = "./bootstrap/volumes"

  providers = {
    restapi    = restapi
    kubernetes = kubernetes
  }

  proxmox_api = var.proxmox

  volumes = {
    pv-test = {
      size = "4G"
      node = "pve"       
    }
  }
}
