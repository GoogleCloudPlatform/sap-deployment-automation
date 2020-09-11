/**
 * Copyright 2018 Google LLC
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

network_tags = ["ssh", "http-server", "https-server"]

instance_name = "sm-s4hana"

autodelete_disk = true

boot_disk_type = "pd-ssd"

disk_type = "pd-standard"

sap_deployment_debug = "false"

public_ip = true

usr_sap_size = 150

sap_mnt_size = 150

swap_size = 30
