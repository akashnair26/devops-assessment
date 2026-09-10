provider "aws" {
  region = var.aws_region

  # plan-only per the assessment brief, no real deploy happens from here.
  # skip_* alone isn't enough - the provider still needs *a* credential source
  # to build a client, so these dummy static creds keep plan working with
  # nothing configured on the machine running it (verified against a clean shell)
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  default_tags {
    tags = {
      Project     = "devops-assessment"
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}
