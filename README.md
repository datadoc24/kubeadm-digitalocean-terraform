# Create a Kubernetes cluster on Digital Ocean using OpenTofu (Terraform)

Creates a 1 master, 2 worker kubernetes cluster as new Digital Ocean droplets using OpenTofu, Bash and Kubeadm.

Tired of spending $$ on keeping your Kubernetes lab running because you can't face reinstalling it? This script and terraform module will create new droplets in your Digital Ocean account and install a cluster on them using kubeadm, then copy the kubeconfig to your local host. The entire process takes only a couple of minutes. When done, quickly destroy the resources using tofu destroy. 


## Initial setup
1 - Install opentofu on your host (all examples here from Ubuntu 22)
```
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
```
2 - Connect to your Digital Ocean console and select the 'API' option in the left-hand menu. Create a new Personal Access Token with custom permissions: all 4 scopes on 'droplet' (create, read, update, delete) and the read scope only on 'ssh key'. Make a copy of the token.

3 - Upload a public key to the SSH Keys section of your Digial Ocean account (or identify an existing one that you want to use for this purpose)

4 - git clone this repo

## Creating and destroying a Kubernetes cluster

1 - export the personal access token you obtained in step 2 above, and the location of your private key
```
export DO_PAT="dop_v1_98059b7430aa32fe918c4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export DO_SSH_KEYFILE=/path/to/your/key.pem
```
2 - cd into the directory that was created when you cloned this repo, then execute the create-do-k8s.sh script
```
cd kubeadm-digitalocean-terraform
./create-do-k8s.sh
```
The script creates 3 droplets (1 master, 2 workers); installs and configures kubernetes packages and containerd on all of them ; initializes kubernetes on the master; executes the kubeadm join command on the 2 workers; adds entries to your /etc/hosts file for k8m1, k8w1, k8w2; and copies the kubeconfig to \~/.kube/do-config on your local host for subsequent use with your local kubectl instance (export KUBECONFIG=\~/.kube/do-config to use it)

3 - when done, destroy the resources to stop spending $$:
```
tofu destroy -var "do_token=${DO_PAT}" -var "pvt_key=$DO_SSH_KEYFILE" -auto-approve
```
