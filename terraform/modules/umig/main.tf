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

data "google_compute_instance" "instances" {
  count  = length(var.instances_self_links)

  self_link = var.instances_self_links[count.index]
}

resource "google_compute_instance_group" "groups" {
  for_each                = local.instances_by_zone

  instances               = each.value
  name                    = "${var.name}-${each.key}"
  project                 = var.project_id
  zone                    = each.key

  dynamic "named_port" {
    for_each              = var.named_ports
    content {
      name                = named_port.value.name
      port                = named_port.value.port
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

