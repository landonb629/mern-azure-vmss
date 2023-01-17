## cosmos db account 
/*
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
*/