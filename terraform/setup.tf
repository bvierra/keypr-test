provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  allowed_account_ids     = [ "557518747328" ]
  region                  = "us-west-2"
}

resource "aws_cloudformation_stack" "kuber" {
  name = "kubernetes-stack"
  parameters {
    AvailabilityZone      = "us-west-2a"
    AdminIngressLocation  = "0.0.0.0/0"
    KeyName               = "bvierra"
    InstanceType          = "m3.medium"
    DiskSizeGb            = "40"
    BastionInstanceType   = "t2.micro"
    K8sNodeCapacity       = "2"
    NetworkingProvider    = "calico"
  }
  capabilities  = [ "CAPABILITY_IAM" ]

  template_url  = "https://s3.amazonaws.com/quickstart-reference/heptio/latest/templates/kubernetes-cluster-with-new-vpc.template"
}
