# ----------------------------------------------------------------------------------------------------------------------
# Create the local variables for both environments: INT and DEV
# ----------------------------------------------------------------------------------------------------------------------

locals {
  env = {
    default = {
      tags = {}
    }

    dev = {
      vpc_cidr_block           = "10.10.0.0/16"
      vpc_enable_dns_support   = true
      vpc_enable_dns_hostnames = true
      vpc_name                 = "dev_vpc"

      public_subnets = [
        {
          name              = "dev_pub_subnet",
          cidr_block        = "10.10.10.0/24",
          availability_zone = "ap-south-1b",
        }
      ]
      private_subnets = [
        {
          name              = "dev_priv_subnet",
          cidr_block        = "10.10.20.128/25",
          availability_zone = "ap-south-1b",
        },
        {
          name              = "dev_priv_subnet_a",
          cidr_block        = "10.10.20.0/28",
          availability_zone = "ap-south-1b",
        },
        {
          name              = "dev_priv_subnet_b",
          cidr_block        = "10.10.20.64/28",
          availability_zone = "ap-south-1c",
        },
        {
          name              = "dev_priv_subnet_a_autoscale",  # new bigger group for autoscaling jobs
          cidr_block        = "10.10.81.0/24",
          availability_zone = "ap-south-1a",
        },
        {
          name              = "dev_priv_subnet_b_autoscale",
          cidr_block        = "10.10.82.0/24",
          availability_zone = "ap-south-1b",
        }
      ]

      tags = {
        "CostCenter"  = "XA9228"
        "Environment" = "DEV"
        "OrgCode"     = "LDA DB"
        "OrgID"       = "A4025821"
        "OrgName"     = "Digital Business"
        "Project"     = "mda_fm_dev"
        "Region"      = "ap-south-1"
        "Terraform"   = true
      }
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create the main VPC along with the private and public subnets
# ----------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "git@code.siemens.com:mda_ops/mda_ops_terraform_modules/terraform-mda-ops-aws-vpc.git?ref=release-v2.0.0"

  vpc_cidr_block           = local.env.dev.vpc_cidr_block
  vpc_enable_dns_support   = local.env.dev.vpc_enable_dns_support
  vpc_enable_dns_hostnames = local.env.dev.vpc_enable_dns_hostnames
  vpc_tags = merge(
    {
      "Name" = local.env.dev.vpc_name
    },
    local.env.dev.tags
  )

  public_subnets     = local.env.dev.public_subnets
  public_subnet_tags = local.env.dev.tags

  private_subnets     = local.env.dev.private_subnets
  private_subnet_tags = local.env.dev.tags
}
