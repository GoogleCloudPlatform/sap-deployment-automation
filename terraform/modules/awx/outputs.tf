output "instance_self_link" {
  description = "Self link of instance"
  value       = length(module.compute_instance.instances_self_links) != 0 ? module.compute_instance.instances_self_links[0] : null
}
