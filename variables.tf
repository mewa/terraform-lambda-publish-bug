provider "aws" {
  region = "eu-central-1"
}

variable "stage" {
  default = "development"
}

locals {
  prod = "${var.stage == "production"}"
}
