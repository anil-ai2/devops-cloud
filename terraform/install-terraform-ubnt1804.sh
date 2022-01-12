sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

echo "adding hashicorp GPG key"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -      

echo "adding hashicorp repo"
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

echo "installing terraorm"
sudo apt-get update && sudo apt-get install terraform
echo "installation complated"

echo "checking the terraform"
terraform -help