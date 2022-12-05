variable "global_settings" {
  description = "Global settings object for the current deployment."
  default = {
    passthrough    = false
    random_length  = 3
    default_region = "eastus2"
  }
}

variable "resource_groups" {
  description = "Configuration object - Resource groups."
  default     = {}
}

variable settings {}