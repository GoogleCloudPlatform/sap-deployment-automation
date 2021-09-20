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

output "ascs_internal_ip" {
  value = module.ascs.internal_ip
}

output "inventory" {
  value  = {
    ascs = [module.ascs.internal_ip],
    db2  = [module.db2.internal_ip],
    pas  = [for k, v in module.as : v.internal_ip if k == local.instance_name_pas]
    aas  = [for k, v in module.as : v.internal_ip if k != local.instance_name_pas],
    nodes = concat(
      [module.ascs.internal_ip, module.db2.internal_ip],
      [for as in module.as : as.internal_ip]),
  }
}
