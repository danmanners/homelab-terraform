locals {
  ssh_users = var.empty_cloud_init == false ? {
    ssh_username = var.ssh_auth.username
    ssh_pubkey   = var.ssh_auth.ed25519_pubkey
  } : null
}