resource "azurerm_public_ip" "vpn" {
  name                = "pins-vpn-public-ip-${local.resource_suffix}"
  location            = azurerm_resource_group.tooling.location
  resource_group_name = azurerm_resource_group.tooling.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3]


  tags = local.tags
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "pins-vpn-${local.resource_suffix}"
  location            = azurerm_resource_group.tooling.location
  resource_group_name = azurerm_resource_group.tooling.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2AZ"

  ip_configuration {
    name                          = "VNetToolingGWpip1"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }

  vpn_client_configuration {
    address_space        = ["10.19.0.0/24"] # 256 IPs
    aad_tenant           = "https://login.microsoftonline.com/5878df98-6f88-48ab-9322-998ce557088d/"
    aad_audience         = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
    aad_issuer           = "https://sts.windows.net/5878df98-6f88-48ab-9322-998ce557088d/"
    vpn_auth_types       = ["AAD"]
    vpn_client_protocols = ["OpenVPN"]
  }

  tags = local.tags
}

# Private DNS Resolver & Inbound Endpoint
resource "azurerm_private_dns_resolver" "vpn" {
  name                = "pins-dns-resolver-vpn-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  virtual_network_id  = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "vpn" {
  name                    = "pins-snet-vpn-resolver-${local.resource_suffix}"
  private_dns_resolver_id = azurerm_private_dns_resolver.vpn.id
  location                = azurerm_resource_group.tooling.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.vpn_resolver.id
  }

  tags = local.tags
}
