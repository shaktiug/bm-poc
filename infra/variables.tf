variable aws_region {}

variable "env" {
  type = string
  description = "(Required) stage."
  default = "dev"
}

variable "project" {
  type = string
  description = "(Required) Project shorthand."
  default     = "orp"
}

