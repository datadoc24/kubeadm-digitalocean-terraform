#!/bin/bash
# Export your Digital Ocean Personal Access Token as DO_PAT
# Export the location of the SSH key that allows access to your Digital Ocean droplets as DO_SSH_KEY_FILE
tofu init
tofu plan -var "do_token=${DO_PAT}" -var "pvt_key=${DO_SSH_KEYFILE}"
tofu apply -var "do_token=${DO_PAT}" -var "pvt_key=${DO_SSH_KEYFILE}" -auto-approve
tofu output > ips.txt

# After the droplets are created and kubeadm has initialized the master, grab the host IPs
MASTER_IP=$(cat ips.txt | grep master_ip_address | awk -F '"' '{print $2}')
W1_IP=$(cat ips.txt | grep w1_ip_address | awk -F '"' '{print $2}')
W2_IP=$(cat ips.txt | grep w2_ip_address | awk -F '"' '{print $2}')

#update entries in /etc/hosts
sudo sed -i '/k8*./d' /etc/hosts
echo "$MASTER_IP k8m1" | sudo tee -a /etc/hosts
echo "$W1_IP k8w1"| sudo tee -a /etc/hosts
echo "$W2_IP k8w2"| sudo tee -a /etc/hosts


#echo "Got master ip of $MASTER_IP, worker 1 ip of $W1_IP, worker 2 ip of $W2_IP"

KUBEJOIN=$(ssh -i $DO_SSH_KEYFILE root@$MASTER_IP "kubeadm token create --print-join-command" | tail -n 1)

#echo "Got a kube join command of: $KUBEJOIN"
#Execute the Kubeadm join command on the 2 workers
ssh -i ~/.ssh/vtadmin.pem root@$W1_IP "$KUBEJOIN" &
ssh -i ~/.ssh/vtadmin.pem root@$W2_IP "$KUBEJOIN" &

wait
scp -i $DO_SSH_KEYFILE root@$MASTER_IP:/etc/kubernetes/admin.conf ~/.kube/config

echo "K8S cluster setup complete and kubeconfig copied to local host"
