output "droplet_output" {
  value = data.digitalocean_droplet.tf_vm_04.ipv4_address
}

