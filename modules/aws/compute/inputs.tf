variable "compute_nodes" {
  description = "List of map objects containing the compute node Name, Instance Size, Subnet ID, and Root volume size; will be iterated through."
  type        = list(any)
}

variable "ami" {
  description = "AMI that the node should be initialized with."
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "Map object containing key=values of the public."
  type        = map(any)
}

variable "architecture" {
  description = "Select 'amd64' or 'arm64' for the EC2 architecture."
  type        = string
}

variable "datestamp" {
  description = "Datestamp for the EC2 AMI data lookup."
  type        = string
}

variable "ssh_auth" {
  description = "Map of key=values with the SSH Username, RSA Pubkey, and ED25519 Pubkey."
  type        = map(any)
}

variable "tags" {
  description = "Map of key=values containing Tags that should be assigned to resources."
  type        = map(any)
}
