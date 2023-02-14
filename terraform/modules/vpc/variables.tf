# Vars rof private subnet
variable "cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "192.168.0.0/24"
}

variable "dns_nameservers" {
  description = "DNS servers for private subnet"
  type        = list(any)
  default     = ["195.210.46.195", "195.210.46.132"]
}

variable "ip_version" {
  description = "IP version for private subnet"
  type        = number
  default     = 4
}

variable "enable_dhcp" {
  description = "DHCP for private subnet"
  type        = bool
  default     = true
}

variable "external_network_id" {
  description = "External network id"
  type        = string
  default     = "0bc2241d-36e4-4edb-8b12-ce9e2c837c45"
}