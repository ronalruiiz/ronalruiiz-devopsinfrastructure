# Create a new SSH key
resource "digitalocean_ssh_key" "sysadmin_ssh" {
  name       = "Terraform Infraestructure"
  public_key = file(var.pub_key)
}

data "digitalocean_project" "default_project" {
  name = "Testing"
}

resource "digitalocean_droplet" "devops_drop" {
    image = "ubuntu-20-04-x64"
    name = "www-1"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    user_data = file("./config/init.yml")
    ssh_keys = [
      digitalocean_ssh_key.sysadmin_ssh.fingerprint
    ]

}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "nyc3"

  forwarding_rule {
    entry_port     = 3000
    entry_protocol = "http"

    target_port     = 3000
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.devops_drop.id]
}


resource "digitalocean_project_resources" "prj_dropp_attach" {
  project = data.digitalocean_project.default_project.id
  resources = [
    digitalocean_droplet.devops_drop.urn,
    digitalocean_loadbalancer.public.urn
  ]
}

/*
resource "null_resource" "exec_resource" {

}
*/
