locals {
  ip_addr = data.digitalocean_droplet.tf_vm_03.ipv4_address
}

locals {
  ssh_rebrain = [for i in jsondecode(data.http.do_api_keys.body)["ssh_keys"]: i.id if i.name == "REBRAIN.SSH.PUB.KEY"]
}

data "external" "take_sshkey" {
  program = ["bash", "key.sh"]
}

locals {
  ssh_rebrain_bash = data.external.take_sshkey.result.id
}

data "external" "take_sshkey_py" {
  program = ["python3", "key.py"]
}

locals {
  ssh_rebrain_py = data.external.take_sshkey_py.result.id
}
