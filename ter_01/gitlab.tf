terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.13.0"
    }
  }
}

provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.base_url
}

data "gitlab_group" "devops_users_3296" {
    full_path = var.full_path
}

resource "gitlab_project" "project_by_tf" {
  name             = "Project from terraform"
  path             = "project_from_terraform"
  description      = "My super duper repo"
  visibility_level = "private"
  namespace_id     =  data.gitlab_group.devops_users_3296.id
}

resource "gitlab_deploy_key" "rebrain_key" {
  project  = gitlab_project.project_by_tf.id
  title    = "Deploy key for Project from terraform"
  key      = var.ssh_key
  can_push = true
}
