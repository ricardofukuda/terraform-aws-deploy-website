variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = false
}

variable "public_subnets" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))

  default = []
}

variable "private_subnets" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))

  default = []
}

variable "high_availability" {
  type        = bool
  description = "Enable high availabilty mode which is going to create an exclusive natgateway for each AZ."
  default     = false
}

variable "tags" {
  default = {}
}