output "droplet_output" {
  value = digitalocean_droplet.tf_vm.*.ipv4_address
}

output "password_for_vms" {
  value = random_string.pass_gen.*.result
}
