output "droplet_output" {
  value = data.digitalocean_droplet.tf_vm_02.ipv4_address
}
