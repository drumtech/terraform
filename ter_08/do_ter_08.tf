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
  count   = length(var.devs.env)
  name    = "${var.devs.dev_name}-${element(var.devs.env, count.index)}"
  type    = "A"
  ttl     = "300"
  records = [element(digitalocean_droplet.tf_vm.*.ipv4_address, count.index)]
}

resource "random_string" "pass_gen"{
  count = length(var.devs.env)
  length = 12
  override_special = "!@#$%^&*()_+-="
  special = true
}

resource "digitalocean_droplet" "tf_vm" {
  count                = length(var.devs.env)
  name                 = "${var.hostname}-${count.index + 1}"
  image                = "centos-7-x64"
  size                 = "s-1vcpu-1gb"
  region               = "fra1"
  ssh_keys             = [digitalocean_ssh_key.my_key.fingerprint]
  tags                 = [digitalocean_tag.my_tag.name, digitalocean_tag.my_email.name]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${path.module}/rebrain")
    host        = self.ipv4_address
  }
  provisioner "remote-exec" {
    inline      = [
      "echo root:\"${element(random_string.pass_gen.*.result, count.index)}\" | chpasswd",
    ]
  }
}

resource "digitalocean_tag" "my_tag" {
  name = "devops"
}

resource "digitalocean_tag" "my_email" {
  name = var.email
}

resource "local_file" "output" {
  content = join("", data.template_file.tmp_data[*].rendered)
  filename = "${path.module}/serverinfo.txt"
}

data "template_file" "tmp_data" {
  template = "${file("${path.module}/my_tmp.tftpl")}"
  count = length(var.devs.env)
  vars = {
    number = count.index + 1
    dns_name = element(aws_route53_record.my_dns.*.name, count.index)
    ip_addr = element(digitalocean_droplet.tf_vm.*.ipv4_address, count.index)
    root_pass = element(random_string.pass_gen.*.result, count.index)
  }
}

