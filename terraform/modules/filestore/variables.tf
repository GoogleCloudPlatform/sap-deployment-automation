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

variable "clients" {
  type        = list(string)
  description = "A list of client IPs that are allowed to connect to the filestore instance."
}

variable "name" {
  type        = string
  description = "The name of the filestore instance."
}

variable "network" {
  type        = string
  description = "The network of the filestore instance."
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the filestore instance is located."
}

variable "share" {
  type        = string
  description = "The name of the share on the filestore instance."
}

variable "size" {
  type        = number
  description = "The size of the filestore instance in GiB. Must be at least 1024 for standard tier and 2560 for premium tier."
  default     = 1024
}

variable "tier" {
  type        = string
  description = "The tier of the filestore instance. Must be one of TIER_UNSPECIFIED, STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, and HIGH_SCALE_SSD"
  default     = "STANDARD"
}

variable "zone" {
  type        = string
  description = "The zone of the filestore instance."
}
