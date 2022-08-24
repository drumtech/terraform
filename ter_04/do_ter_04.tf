terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-west-1"
  default_tags {
    tags = {
      module = "devops"
      email  = var.email
    }
  }
}

resource "digitalocean_ssh_key" "my_key" {
  name       = "kuptsov_pub_key"
  public_key = var.ssh_key
}

data "aws_route53_zone" "rebrain_zone_id" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "my_dns" {
  zone_id = data.aws_route53_zone.rebrain_zone_id.zone_id
  count   = 1
  name    = var.pc_name
  type    = "A"
  ttl     = "300"
  records = [local.ip_addr]
}

resource "digitalocean_droplet" "tf_vm_04" {
  name                 = "tf-vm-04"
  image                = "centos-7-x64"
  size                 = "s-1vcpu-1gb"
  region               = "fra1"
  ssh_keys             = [digitalocean_ssh_key.my_key.fingerprint]
  tags                 = [digitalocean_tag.my_tag.name, digitalocean_tag.my_email.name]
}

resource "digitalocean_tag" "my_tag" {
  name = "devops"
}

resource "digitalocean_tag" "my_email" {
  name = var.email
}
