module "vault_pki" {
  source      = "github.com/devops-adeel/terraform-vault-secrets-pki?ref=v0.1.0"
  application = "foo"
}

module "vault_aws_auth" {
  source   = "github.com/devops-adeel/terraform-vault-auth-aws?ref=v0.2.0"
  policies = [module.vault_pki.policy_name]
}
