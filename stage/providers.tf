provider "aws" {
  profile = "default"

  default_tags {
    tags = local.common_tags
  }
}
