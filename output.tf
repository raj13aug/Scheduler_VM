output "instance_ip" {
  value = google_compute_instance.demo.network_interface.0.access_config.0.nat_ip
}

output "instance_ssh_key" {
  value      = "${abspath(path.root)}/ssh_key"
  depends_on = [tls_private_key.ssh]
}