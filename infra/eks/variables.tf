locals {
    common-tags = {
        Environment = var.tgAmbiente
        Owner = "challenge01"
        Management = "terraform"
    }
}

# GLOBAL TAGS
variable "tgAmbiente" {
    type = string
    default = "prod"
}

# AUTH VARS
variable "AWS_REGION" {
    description = "AWS Region"
    type = string
    default = "us-east-1"
}
variable "AWS_AUTH_FILE" {
    description = "credentials file path"
    type = string
    default = "~/.aws/credentials"
}
variable "AWS_AUTH_PROFILE" {
    description = "profile in credentials file"
    type = string
    default = "default"
}