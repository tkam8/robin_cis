# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


# Use below code as backup to dependency block as last resort
// data "terraform_remote_state" "vpc" {
//     backend = "gcs"
//   config = {
//     bucket         = "tky-drone-demo-stage"
//     prefix         = "terraform/state"
//     region         = "asia-northeast1"
//   }
// }

terraform {
  source = "github.com/tkam8/robin_cis_modules//ansible_files?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "bigip1" {
  config_path = "../functions/bip1"

  mock_outputs = {
    bigip1_public_ip    = "1.1.1.1"
    bigip1_private_ip   = "2.2.2.2"
  }
}

dependency "bigip2" {
  config_path = "../functions/bip2"

  mock_outputs = {
    bigip2_public_ip    = "1.1.1.2"
    bigip2_private_ip   = "2.2.2.3"
  }
}

dependency "bigip3" {
  config_path = "../functions/bip3"

  mock_outputs = {
    bigip3_public_ip    = "1.1.1.3"
    bigip3_private_ip   = "2.2.2.4"
  }
}

dependency "robin1" {
  config_path = "../functions/robin_master1"

  mock_outputs = {
    robin1_public_ip    = "1.1.1.4"
    robin1_private_ip   = "2.2.2.5"
  }
}
dependency "robin2" {
  config_path = "../functions/robin_worker1"

  mock_outputs = {
    robin2_public_ip    = "1.1.1.5"
    robin2_private_ip   = "2.2.2.6"
  }
}
dependency "robin3" {
  config_path = "../functions/robin_worker2"

  mock_outputs = {
    robin3_public_ip    = "1.1.1.6"
    robin3_private_ip   = "2.2.2.7"
  }
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path              = "${get_terragrunt_dir()}"
  app_tag_value                = "terryrobincis"
  robin1_endpoint                = dependency.robin1.outputs.centos_public_ip
  robin2_endpoint                = dependency.robin2.outputs.centos_public_ip
  robin3_endpoint                = dependency.robin3.outputs.centos_public_ip
  // cluster1_username            = dependency.gke1.outputs.cluster_username
  // cluster2_username            = dependency.gke2.outputs.cluster_username
  // cluster3_username            = dependency.gke3.outputs.cluster_username
  // cluster1_password            = dependency.gke1.outputs.cluster_password
  // cluster2_password            = dependency.gke2.outputs.cluster_password
  // cluster3_password            = dependency.gke3.outputs.cluster_password
  bigip1_public_ip             = dependency.bigip1.outputs.f5_public_ip
  bigip2_public_ip             = dependency.bigip2.outputs.f5_public_ip
  bigip3_public_ip             = dependency.bigip3.outputs.f5_public_ip
  bigip1_private_ip            = dependency.bigip1.outputs.f5_private_ip
  bigip2_private_ip            = dependency.bigip2.outputs.f5_private_ip
  bigip3_private_ip            = dependency.bigip3.outputs.f5_private_ip
}
