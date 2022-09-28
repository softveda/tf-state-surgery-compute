output "backend_public_ip" {
  value = module.ubuntu-vm.vm_public_ip
}

output "tls_private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

