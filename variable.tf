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

variable "environment" {
  description = "Environment tag to help identify the entire deployment"
  type        = string
  default     = "workforce"
}

variable "project_name" {
  description = "Prefix of Google Project name"
  type        = string
  default     = "prj"
}

variable "org_id" {
  description = "The numeric organization id"
  type        = string
}

variable "folder_id" {
  description = "The folder to deploy project in"
  type        = string
}

variable "billing_account" {
  description = "The billing account id associated with the project, e.g. XXXXXX-YYYYYY-ZZZZZZ"
  type        = string
}

variable "workforce_pool_id" {
  type        = string
  description = "workforce"
}

variable "location" {
  type        = string
  description = "Location of the Pool"
}

variable "display_name" {
  type        = string
  default     = "Google Cloud Access"
  description = "Display name of the Pool"
}

variable "description" {
  type        = string
  default     = "Google Cloud Access"
  description = "Description of the Pool"
}

variable "disabled" {
  type        = bool
  default     = false
  description = "Enable the Pool"
}

variable "session_duration" {
  type        = string
  default     = "3600s"
  description = "Session Duration"
}

variable "wif_providers" {
  type        = list(any)
  description = "Provider config"
}

variable "attribute_mapping" {
  type        = map(string)
  description = "attribute list"
}

variable "attribute_condition" {
  type        = string
  description = "Workforce Identity Pool Provider attribute condition expression"
}


variable "prefix" {
  description = "Prefix member or group or serviceaccount"
  type        = string
  default     = "principalSet"
}

variable "role" {
  description = "IAM role for Workforce testing"
  type        = string
}

variable "group_id" {
  description = "Group name in Identity Provider "
  type        = string
}

