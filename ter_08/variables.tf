variable "ssh_key" {
  type = string
}

variable "do_token" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "email" {
  type = string
}

variable "hostname" {
  type = string
}

variable "devs" {
  type = object({
    dev_name = string
    env = list(string)
  })
  default = {
    dev_name = "pisos_at_mail_ru"
    env = ["app1", "redis-host", "db-host", "haproxy"]
  }
}
