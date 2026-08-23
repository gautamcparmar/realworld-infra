# Local state is the default so a first apply works without extra bootstrap.
# For shared / production use, configure a remote backend, for example:
#
#   terraform init \
#     -backend-config="bucket=YOUR_TF_STATE_BUCKET" \
#     -backend-config="key=production/terraform.tfstate" \
#     -backend-config="region=us-east-1" \
#     -backend-config="use_lockfile=true" \
#     -backend-config="encrypt=true"
#
terraform {
  backend "s3" {
    bucket       = "realworld-tf-state-217478635962-ap-south-1-an"
    key          = "stage/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
    profile      = "default"
  }
}
