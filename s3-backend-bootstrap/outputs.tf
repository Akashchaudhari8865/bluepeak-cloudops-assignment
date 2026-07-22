output "terraform_state_bucket_name" {
  description = "Terraform State Bucket Name"

  value = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "Terraform State Bucket ARN"

  value = aws_s3_bucket.terraform_state.arn
}

output "terraform_backend_config" {

  description = "Use this bucket name in backend.tf"

  value = <<EOT
bucket       = "${aws_s3_bucket.terraform_state.bucket}"
key          = "dev/terraform.tfstate"
region       = "${var.aws_region}"
use_lockfile = true
encrypt      = true
EOT

}