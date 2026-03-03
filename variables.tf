# variable "resourcename" {
#   default     = "gttftestpl01"
#   description = "This is an Azure Resource Group"
# }

variable "location" {
  type        = string
  description = "The name of the key vault to be created. The value will be randomly generated if blank."
  default     = "eastus2"
}

## Allows to be locked to a ceratin region.
# variable "location" {
#   validation {
#     condition     = can(regex("^eastus2", var.location))
#     error_message = "The location should be in EAST US 2."
#   }
# }

variable "containername" {
  type        = string
  description = "The name of the key vault to be created. The value will be randomly generated if blank."
  default     = "gtazstgct01"
}

variable "storagename" {
  type        = string
  description = "The name of the key vault to be created. The value will be randomly generated if blank."
  default     = "gtazurestg01"
}

############################
##         Tags           ##
############################
variable "tags" {
  description = "Basic Tags"
  type        = map(string)
  default = {
    environment = "sandbox",
    owner       = "ownername",
    pourpose    = "pourposename",
    costcenter  = "costcentername",
    chargecode  = "000000000"
  }
}

variable "tags2" {
  description = "Basic Tags"
  type        = map(string)
  default = {
    environment = "sandbox",
    resource    = "sqltst01",
    owner       = "ownername",
    pourpose    = "pourposename",
    costcenter  = "costcentername",
    chargecode  = "000000000"
  }
}