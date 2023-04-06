# Challenge #1
# A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these
# resources on a cloud environment (Azure/AWS/GCP). Please remember we will not be judged
# on the outcome but more focusing on the approach, style and reproducibility.

# Configure the Azure provider
provider "azurerm" {
  subsubscription_id = ""
  tenant_id = ""  
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet for the application gateway
resource "azurerm_subnet" "appgw" {
  name                 = "appgw-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a subnet for the web tier
resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Cosmos DB account
resource "azurerm_cosmosdb_account" "example" {
  name                = "example-cosmosdb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
}

# Create an application gateway
resource "azurerm_application_gateway" "example" {
  name                = "example-appgw"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw.id
  }
  frontend_port {
    name = "http"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "appgw-fe-ip-config"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }
  backend_address_pool {
    name = "appgw-be-pool"
  }
  backend_http_settings {
    name                  = "appgw-be-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }
  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_id  = azurerm_application_gateway.example.frontend_ip_configuration[0].id
    frontend_port_id               = azurerm_application_gateway.example.frontend_port[0].id
    protocol                       = "Http"
    host_name                      = "example.com"
    require_server_name_indication = true
  }
  request_routing_rule {
    name                       = "appgw-http-rule"
    rule_type                  = "Basic"
    http_listener_name         = azurerm_application_gateway.example.http_listener[0].name
    backend_address_pool_name  = azurerm_application_gateway.example.backend_address_pool[0].name
    backend_http_settings_name = azurerm_application_gateway.example.backend_http_settings[0].name
  }
}

# Create an App Service plan for the web tier
resource "azurerm_app_service_plan" "example" {
  name                = "example-appservice-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create an App Service for the web tier
resource "azurerm_app_service" "example" {
  name                = "example-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  site_config {
    always_on = true
  }
  app_settings = {
    "COSMOSDB_CONNECTION_STRING" = azurerm_cosmosdb_account.example.connection_strings[0]
  }  
}

# Connect the App Service to the Cosmos DB account
resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "example-db"
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_cosmosdb_account.example.name
}

