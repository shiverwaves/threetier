# terraform

# provider
provider "aws" {
  region = var.region
}

# modules
module "network" {
  source = "./net"

  project = var.project
  # network variables
  vpc_cidr     = var.vpc_cidr
  public_cidr  = var.public_cidr
  private_cidr = var.private_cidr
}

module "app" {
  source = "./app"

  project = var.project
  # network inputs
  vpc_id              = module.network.vpc_id
  public_subnet_id    = module.network.public_subnet_id
  public_subnet_cidr  = module.network.public_subnet_cidr
  private_subnet_id   = module.network.private_subnet_id
  private_subnet_cidr = module.network.private_subnet_cidr
}
