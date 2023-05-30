
output "webapp_url_linux" {
  sensitive = true
  value     = [for lin_webapp in azurerm_linux_web_app.webapp : lin_webapp.default_hostname]
}

output "webapp_url_windows" {
  sensitive = true
  value     = [for win_webapp in azurerm_windows_web_app.webapp : win_webapp.default_hostname]
}

