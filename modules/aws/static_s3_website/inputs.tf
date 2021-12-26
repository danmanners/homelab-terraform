variable "root_domain" {
  description = "Top level domain to lookup for the Route53 Zone."
  type        = string
}
variable "domain_name" {
  description = "Primary domain name for the ACM cert."
}

variable "subject_alt_names" {
  description = "List of strings containing for each of the SANs to create."
  type        = list(string)
  default     = []
}

variable "all_route53_records" {
  description = "List of strings of each of the domain records to create (example: ['.','www'])"
  type        = list(string)
  default     = ["www", "."]
}
