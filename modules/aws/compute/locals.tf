locals {
  ssh_users = {
    ssh_username  = var.ssh_auth.username
    ssh_pubkey    = var.ssh_auth.pubkey
  }
}