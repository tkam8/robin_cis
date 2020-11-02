

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/robin_cis_modules//gcp_f5_standalone_1NIC?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    network             = "networkName"
    public_subnetwork   = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  #skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above. Note the BIGIP_PASS value of default will never be set on later versions
inputs = {
  name_prefix       = "cis-scalen-bip1"
  project           = "f5-gcs-4261-sales-apcj-japan"
  region            = "asia-northeast1"
  zone              = "asia-northeast1-b"
  network           = dependency.vpc.outputs.network
  subnetwork        = dependency.vpc.outputs.public_subnetwork
  f5_instance_type  = "n1-standard-4"
  BIGIP_PASS        = get_env("BIGIP_PASS", "default")
  TS_URL            = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.15.0/f5-telemetry-1.15.0-4.noarch.rpm"
  AS3_URL           = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.23.0/f5-appsvcs-3.23.0-5.noarch.rpm"
  DO_URL            = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.16.0/f5-declarative-onboarding-1.16.0-8.noarch.rpm"
}

