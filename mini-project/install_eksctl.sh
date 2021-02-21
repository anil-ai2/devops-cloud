sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin
eksctl version

cat <<EOF
    # cluster provisioning comamnd 
    eksctl create cluster --name dev --version 1.16 --region us-east-1 --nodegroup-name standard-workers --node-type t3.micro --nodes 3 --nodes-min 1 --nodes-max 4 --managed
    eksctl get cluster  
    aws eks update-kubeconfig --name dev --region us-east-1
EOF