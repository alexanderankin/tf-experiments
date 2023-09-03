# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rg.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription#example-usage
data "azurerm_subscription" "current" {
}

# https://journeyofthegeek.com/2023/04/06/authorization-in-azure-openai-service/
resource "azurerm_role_definition" "oai_user" {
  name  = "oai_user"
  scope = data.azurerm_subscription.current.id
  permissions {
    actions = [
      "Microsoft.CognitiveServices/*/read",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleDefinitions/read"
    ]

    // https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftcognitiveservices
    data_actions = [
      "Microsoft.CognitiveServices/accounts/OpenAI/*/read",
      "Microsoft.CognitiveServices/accounts/OpenAI/engines/completions/action",
      "Microsoft.CognitiveServices/accounts/OpenAI/engines/search/action",
      "Microsoft.CognitiveServices/accounts/OpenAI/engines/generate/action",
      # "Microsoft.CognitiveServices/accounts/OpenAI/engines/completions/write",
      "Microsoft.CognitiveServices/accounts/OpenAI/deployments/search/action",
      "Microsoft.CognitiveServices/accounts/OpenAI/deployments/completions/action",
      "Microsoft.CognitiveServices/accounts/OpenAI/deployments/embeddings/action",
      # "Microsoft.CognitiveServices/accounts/OpenAI/deployments/completions/write",
    ]
  }
}

resource "azurerm_role_definition" "oai_contributor" {
  name  = "oai_user"
  scope = data.azurerm_subscription.current.id
  permissions {
    actions = [
      "Microsoft.CognitiveServices/*/read",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleDefinitions/read",
    ]
    data_actions = [
      "Microsoft.CognitiveServices/accounts/OpenAI/*",
    ]
  }
}

resource "azurerm_role_definition" "azure_cs_user" {
  name  = "oai_user"
  scope = data.azurerm_subscription.current.id
  permissions {
    actions = [
      "Microsoft.CognitiveServices/*/read",
      "Microsoft.CognitiveServices/accounts/listkeys/action",
      "Microsoft.Insights/alertRules/read",
      "Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Insights/logDefinitions/read",
      "Microsoft.Insights/metricdefinitions/read",
      "Microsoft.Insights/metrics/read",
      "Microsoft.ResourceHealth/availabilityStatuses/read",
      "Microsoft.Resources/deployments/operations/read",
      "Microsoft.Resources/subscriptions/operationresults/read",
      "Microsoft.Resources/subscriptions/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Support/*",
    ]
    data_actions = [
      "Microsoft.CognitiveServices/*",
    ]
  }
}
