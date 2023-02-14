module "ec2_instance" {
  source      = "github.com/devops-adeel/terraform-aws-ec2?ref=v0.1.0"
  application = "foo"
  api_name    = "bar"
  hcp_bucket  = "bucket_1234"
}
