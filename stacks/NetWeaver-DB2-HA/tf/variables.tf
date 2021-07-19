/**
 * Copyright 2021 Google LLC
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
variable "disk_size_boot" { type = number }

variable "disk_size_db2" { type = number }

variable "disk_size_swap" { type = number }

variable "disk_size_usrsap" { type = number }

variable "disk_type_boot" {}

variable "disk_type_db2" {}

variable "disk_type_swap" {}

variable "disk_type_usrsap" {}

variable "ers_ilb_required" { type = bool }

variable "filestore_name" {}

variable "filestore_size" { type = number }

variable "filestore_tier" {}

variable "gce_ssh_user" {}

variable "gce_ssh_pub_key_file" {}

variable "health_check_port_ascs" { type = number }

variable "health_check_port_db2" { type = number }

variable "health_check_port_ers" { type = number }

variable "instance_basename_as" {}

variable "instance_name_ascs" {}

variable "instance_name_db2_primary" {}

variable "instance_name_db2_secondary" {}

variable "instance_name_ers" {}

variable "instance_type_as" {}

variable "instance_type_ascs" {}

variable "instance_type_ers" {}

variable "instance_type_db2" {}

variable "network_tags" { type = list(string) }

variable "num_instances_as" { type = number }

variable "project_id" {}

variable "service_account_email" {}

variable "source_image" {}

variable "source_image_family" {}

variable "source_image_project_id" {}

variable "subnetwork" {}

variable "subnetwork_project_id" {}

variable "zone_primary" {}

variable "zone_secondary" {}
