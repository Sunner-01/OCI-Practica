terraform {
  required_version = ">= 1.12.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.0.0, < 9.0.0"
    }
  }

  backend "oci" {
    bucket              = "terraform-estado-practica"
    namespace           = "gr23tbuggx3b"
    key                 = "oci-practica/terraform.tfstate"
    config_file_profile = "DEFAULT"
  }
}



