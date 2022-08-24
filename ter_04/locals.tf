locals {
  ip_addr = data.digitalocean_droplet.tf_vm_04.ipv4_address
}

data "digitalocean_droplet" "tf_vm_04" {
  name = digitalocean_droplet.tf_vm_04.name
}

