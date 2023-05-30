variable "environment" {
  type = set(string)
  default = ["dev","uat","prod"]
  description = "Environment name"
}

variable "resource_group_name" {
  type = string
  default     = "myRG-dotnetapp-lin"
  description = "Name of the resource group."
}

variable "resource_group_location" {
  type = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "OStype" {
  type        = string
  default     = "Linux"
  description = "web app service plan OS"
}

variable "SKU" {
  type        = string
  default     = "B1"
  description = "web app service plan SKU"
}

variable "Repo_URL" {
  type        = string
  default     = "https://github.com/Azure-Samples/dotnetcore-docs-hello-world"
  #default     = "https://github.com/Eswari303/python-docs-hello-world"
  description = "Webapp source repo URL"
}

