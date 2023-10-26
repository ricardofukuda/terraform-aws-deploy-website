variable "name" {
  type = string
}

variable "internal" {
  type = bool

  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(object({
    description      = string,
    from_port        = number,
    to_port          = number,
    protocol         = string,
    cidr_blocks      = list(string),
    ipv6_cidr_blocks = list(string),
    prefix_list_ids  = list(string),
    security_groups  = list(string),
    self             = bool
  }))

  default = []
}

variable "egress_rules" {
  type = list(object({
    description      = string,
    from_port        = number,
    to_port          = number,
    protocol         = string,
    cidr_blocks      = list(string),
    ipv6_cidr_blocks = list(string),
    prefix_list_ids  = list(string),
    security_groups  = list(string),
    self             = bool
  }))

  default = []
}

variable "certificate_arn" {
  type = string
}

variable "tags" {
  default = {}
}