output "umig_self_link" {
  value = join("", module.umig.self_links)
}

output "instance_names" {
  value = [for link in module.umig.instances_self_links : split("/", link)[10]]
}

output "instance_ips" {
  value = google_compute_address.internal_ip.*.address
}
