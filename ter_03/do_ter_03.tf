terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    http = {
      source = "hashicorp/http"
      version = "2.1.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "my_key" {
  name       = "kuptsov_pub_key"
  public_key = var.ssh_key
}

resource "digitalocean_droplet" "tf_vm_03" {
  name                 = "tf-vm-03"
  image                = "centos-7-x64"
  size                 = "s-1vcpu-1gb"
  region               = "fra1"
  ssh_keys             = [digitalocean_ssh_key.my_key.fingerprint, local.ssh_rebrain[0]]
  tags                 = [digitalocean_tag.my_tag.name, digitalocean_tag.my_email.name]
}

data "digitalocean_droplet" "tf_vm_03" {
  name = digitalocean_droplet.tf_vm_03.name
}

resource "digitalocean_tag" "my_tag" {
  name = "devops"
}

resource "digitalocean_tag" "my_email" {
  name = var.email
}

data "http" "do_api_keys" {
  url = var.api_do_wit_keys
  request_headers = {
    Content-Type = "application/json"
    Authorization = "Bearer ${var.do_token}" 
  }
}

