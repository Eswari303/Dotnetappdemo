
# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


/*
# Use existing RG
data "azurerm_resource_group" "myrg" {
  name = var.resource_group_name
}
*/

# Create the Linux/Windows App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = var.OStype
  sku_name            = var.SKU
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  for_each = var.OStype == "Linux" ? toset(var.environment) : toset([])
  //count = "${var.OStype == "Linux" ? 1 : 0}"
  name                  = "webapp-linux-${each.key}-${random_integer.ri.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      dotnet_version = "7.0"

    }
  }
tags = {
  Environment = each.value
  // each.key = each.value in this case 
}
}

resource "azurerm_windows_web_app" "webapp" {
  for_each = var.OStype == "Windows" ? toset(var.environment) : toset([])
  //count = "${var.OStype == "Windows" ? 1 : 0}"
  name                = "webapp-win-${each.key}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v7.0"
      
    }
  }
tags = {
  Environment = each.value
  // each.key = each.value in this case 
}
}


#  Deploy code from a public GitHub repo 
resource "azurerm_app_service_source_control" "sourcecontrol" {
  for_each = azurerm_linux_web_app.webapp
 // count = "${var.OStype == "Linux" ? 1 : 0}"
 // count.index should replace with each.key
  app_id             = azurerm_linux_web_app.webapp[each.key].id
  repo_url           = var.Repo_URL
  branch             = "master"
  use_manual_integration = true //External Git
 # use_manual_integration = false  // CI/CD - Github, Local git, Azure Repo etc.,
} 


#  Deploy code from a public GitHub repo - Windows
resource "azurerm_app_service_source_control" "sourcecontrol_win" {
  for_each = azurerm_windows_web_app.webapp
 // count = "${var.OStype == "Windows" ? 1 : 0}"
  app_id             = azurerm_windows_web_app.webapp[each.key].id
  repo_url           = var.Repo_URL
  branch             = "master"
  use_manual_integration = true
}