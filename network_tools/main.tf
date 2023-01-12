terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "./modules/resource_group"
  rg_name = "net_lab"
  location = "northeurope"
}

module "vpc" {
  source   = "./modules/vpc"
  rg_name  = module.resource_group.rg_name
  location = module.resource_group.location
}

module "instances" {
  source   = "./modules/ecs"
  rg_name  = module.resource_group.rg_name
  location = module.resource_group.location

  nic1_id_lab1 = module.vpc.nic1_id_lab1
  nic2_id_lab1 = module.vpc.nic2_id_lab1
  nic1_id_lab2 = module.vpc.nic1_id_lab2
  nic1_id_lab3 = module.vpc.nic1_id_lab3
}
