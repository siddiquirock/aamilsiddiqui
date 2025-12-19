module "resource-group" {
  source              = "../childmodule/azure_resource_group"
  resource_group_name = "dev0rg"
  location            = "ukwest"
}

module "virtual-network" {
  depends_on           = [module.resource-group]
  source               = "../childmodule/azure_vnet"
  resource_group_name  = "dev0rg"
  location             = "ukwest"
  virtual_network_name = "dev0vnet"   # 👈 match with VM
  address_space        = ["10.0.0.0/16"]
}

module "subnet" {
  depends_on           = [module.virtual-network]
  source               = "../childmodule/azure_subnet"
  resource_group_name  = "dev0rg"
  virtual_network_name = "dev0vnet"   # 👈 match with VNET
  subnet_name          = "dev0subnet"  # 👈 match with VM
  address_prefixes     = ["10.0.2.0/24"]
}

module "public-ip" {
  depends_on          = [module.resource-group]
  source              = "../childmodule/azure_pip"
  resource_group_name = "dev0rg"
  location            = "ukwest"
  public_ip_name      = "dev0pip"     # 👈 match with VM
}

module "key_vault" {
  depends_on          = [module.resource-group]
  source              = "../childmodule/azure_keyvault"
  key_vault_name      = "k931216"
  resource_group_name = "dev0rg"
  location            = "ukwest"
}

module "keyvaultsecret" {
  depends_on          = [module.key_vault]
  source              = "../childmodule/azure_keyvaultsecret" # 👈 alag module banao
  key_vault_name      = "k931216"
  resource_group_name = "dev0rg"
 
}

module "virtual-machine" {
  depends_on = [
    module.resource-group,
    module.virtual-network,
    module.subnet,
    module.public-ip,
    module.key_vault,
    module.keyvaultsecret
  ]

  source               = "../childmodule/azure_vm"
  resource_group_name  = "dev0rg"
  location             = "ukwest"
  vm_name              = "dev0vm"
  virtual_network_name = "dev0vnet"
  subnet_name          = "dev0subnet"
  public_ip_name       = "dev0pip"
  nic_name             = "dev0nic"
  key_vault_name       = "k931216"
  username_secret_name = "vm-admin-username"
  password_secret_name = "vm-admin-password"
}

