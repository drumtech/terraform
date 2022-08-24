output "droplet_output" {
  value = data.digitalocean_droplet.tf_vm_03.ipv4_address
}
