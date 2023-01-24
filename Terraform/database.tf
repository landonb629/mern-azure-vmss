## cosmos db account 

resource "azurerm_cosmosdb_account" "db-account" {
name =   var.cosmos_db_account
resource_group_name = azurerm_resource_group.rg.name
location = var.location
offer_type = "Standard"
kind = "MongoDB"

consistency_policy {
  consistency_level = "BoundedStaleness"
}

geo_location {
  location = "eastus"
  failover_priority = 0
}

enable_automatic_failover = false
public_network_access_enabled = false

depends_on = [
  azurerm_virtual_network.vnet
]
}

resource "azurerm_cosmosdb_mongo_database" "login-db" {
  name = var.cosmos_db
  resource_group_name = azurerm_resource_group.rg.name
  account_name = azurerm_cosmosdb_account.db-account.name

  
  depends_on = [
    azurerm_cosmosdb_account.db-account,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_private_endpoint" "db-access" {
  name  = "mern-app-db"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id = azurerm_subnet.subnets["db"].id
  
  
  private_service_connection {
    name = "mern-app-db-connection"
    private_connection_resource_id  = azurerm_cosmosdb_account.db-account.id
    is_manual_connection = false
    subresource_names = [azurerm_cosmosdb_account.db-account.kind]

  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.login-db,
    azurerm_cosmosdb_account.db-account
  ]
  }
