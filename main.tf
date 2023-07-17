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


module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 11.0"

  name              = "${var.project_name}-${var.environment}-${random_id.random_suffix.hex}"
  random_project_id = "false"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "iam.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com"
  ]
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

resource "google_iam_workforce_pool" "pool" {
  provider          = google-beta
  workforce_pool_id = var.workforce_pool_id
  parent            = "organizations/${var.org_id}"
  location          = var.location
  display_name      = var.display_name
  description       = var.description
  disabled          = var.disabled
  session_duration  = var.session_duration
}


resource "google_iam_workforce_pool_provider" "provider" {
  provider          = google-beta
  for_each          = { for i in var.wif_providers : i.provider_id => i }
  workforce_pool_id = google_iam_workforce_pool.pool.workforce_pool_id
  location          = google_iam_workforce_pool.pool.location
  provider_id       = each.value.provider_id
  attribute_mapping = lookup(each.value, "attribute_mapping", null) == null ? null : each.value.attribute_mapping

  dynamic "saml" {
    for_each = lookup(each.value, "select_provider", null) == "saml" ? ["1"] : []
    content {
      idp_metadata_xml = each.value.provider_config.idp_metadata_xml
    }
  }

  dynamic "oidc" {
    for_each = lookup(each.value, "select_provider", null) == "oidc" ? ["1"] : []
    content {
      issuer_uri = each.value.provider_config.issuer_uri
      client_id  = each.value.provider_config.client_id
      dynamic "web_sso_config" {
        for_each = lookup(each.value.provider_config, "web_sso_response_type", null) != null && lookup(each.value.provider_config, "web_sso_assertion_claims_behavior", null) != null ? ["1"] : []
        content {
          response_type             = each.value.provider_config.web_sso_response_type
          assertion_claims_behavior = each.value.provider_config.web_sso_assertion_claims_behavior
        }
      }
    }
  }

  display_name        = lookup(each.value, "display_name", null)
  description         = lookup(each.value, "description", null)
  disabled            = lookup(each.value, "disabled", false)
  attribute_condition = lookup(each.value, "attribute_condition", null)
}


module "member_roles" {
  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  for_each                = { for account in var.project_bindings : account.project_id => account }
  service_account_address = "//iam.googleapis.com/${google_iam_workforce_pool.pool.name}/${each.value.attribute}"
  prefix                  = each.value.all_identities == false ? "principal" : "principalSet"
  project_id              = each.value.project_id
  project_roles           = each.value.roles
}