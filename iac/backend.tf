#Este bucket guarda el estado de Terraform

terraform {
  backend "s3" {
    bucket  = "terraform-state-webplatform"
    key     = "nextcloud/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}  