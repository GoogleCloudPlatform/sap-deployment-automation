/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
output "vpc" {
  description = "Output of all VPC related values"
  value       = module.vpc
}

output "project_id" {
  description = "Test project ID"
  value       = module.vpc.project_id
}

output "region" {
  description = "Default Region where resources are deployed"
  value       = var.region
}

output "state_bucket" {
  description = "State bucket for forminator"
  value       = google_storage_bucket.state_bucket.name
}

output "network_tags" {
  description = "Network tags used by forminator"
  value       = var.network_tags
}

output "public_key_openssh" {
  description = "SSH Public Key used by forminator and ansible"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_openssh" {
  description = "SSH Private Key used by forminator and ansible"
  sensitive   = true
  value       = tls_private_key.ssh_key.private_key_openssh
}

output "bastion_ip" {
  description = "Bastion External IP used by forminator and ansible"
  value       = google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip
}

output "sap_service_account" {
  description = "SAP Service Account for VMs"
  value       = google_service_account.sap_service_account.email
}

output "media_bucket" {
  description = "Bucket where SAP installation files are located"
  value       = google_storage_bucket.media_bucket.name
}