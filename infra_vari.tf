#az login
#az account set --subscription ec045313-a080-4ec4-8aeb-48d1c8e68a4c
#Variables defined
#terraform fmt, terraform validate, terraform plan, terraform apply -auto-approve, terraform destroy

variable "name_of_resource_group" {
  default     = "John-Dev"
  type        = string
  description = "Name Of Resource G"
}

variable "tags" {
  default     = "Production"
  type        = string
  description = "Name of Environ"
}

variable "location" {
  default     = "west US"
  type        = string
  description = "First Location"
}

variable "virtual_network" {
  default     = "MyVnet"
  type        = string
  description = "(optional) describe your variable"
}

variable "NSG" {
  default     = "Jbravo-NSG"
  type        = string
  description = "(optional) describe your variable"
}

variable "Vnet-interface" {
  default = "John-nic"
  type = string
  description = "(optional) describe your variable"
}

variable "ip-configuration" {
  default = "ip-config"
  type = string
  description = "(optional) describe your variable"
}

variable "adminuser" {
  default = "John-VM"
  type = string
  description = "(optional) describe your variable"
}

variable "passwd" {
  default = "Jbravo1234@"
  type = string
  description = "(optional) describe your variable"
}

variable "SA-name" {
  default = "John-SA"
  type = string
  description = "(optional) describe your variable"
}

variable "MSSQL_name" {
  default = "John-MSSQL"
  type = string
  description = "(optional) describe your variable"
}

variable "DB_name" {
  default = "John_DBA"
  type = string
  description = "(optional) describe your variable"
}

variable "John_FileShare" {
  default = "John_FileShareName"
  type = string
  description = "(optional) describe your variable"
}

variable "ID" {
  default = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
  type = string
  description = "(optional) describe your variable"
}