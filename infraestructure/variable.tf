variable "location" {
    description = "The azure region in which all resources groups should be created"
    type=string
}

variable "resource_group_name" {
    description = "the name of the resource group"
    type= string
}

variable "environment" {
    description = "environment"
    type= string
}

variable "azurerm_postgresql_database_name" {
    description= "database name"
    type =string
  
}