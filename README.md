Please edit the following files:
 * terraform/setup.tf
   * change the KeyName to an SSH key that is already uploaded to the account and you have access to

You need to have the following installed and in path
 * kubectl
 * terraform

Run kube-setup.sh to install everything, the logs will then be in cloudwatch

To terminate all run kube-destroy.sh to remove everything

**THIS WILL SETUP A SYSTEM THAT HAS CHARGES ASSOCIATED WITH IT**


Special thanks to Amazon for taking over 7hrs to approve my AWS account! (Sorry for it not being more polished)
