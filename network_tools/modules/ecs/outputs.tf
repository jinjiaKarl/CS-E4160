output "lab1_ip_addr" {
  value = azurerm_linux_virtual_machine.lab1.public_ip_address
}
output "lab2_ip_addr" {
  value = azurerm_linux_virtual_machine.lab2.public_ip_address
}
output "lab3_ip_addr" {
  value = azurerm_linux_virtual_machine.lab3.public_ip_address
}