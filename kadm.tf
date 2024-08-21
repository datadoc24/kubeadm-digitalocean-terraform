resource "digitalocean_droplet" "k8m1" {
  image = "ubuntu-24-04-x64"
  name = "k8m1"
  region = "sfo3"
  size = "s-2vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.vtadmin.id
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl gpg lsb-release",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt-get update",
      "apt-get install -y containerd && sudo systemctl enable containerd",
      "mkdir /etc/containerd",
      "containerd config default | sudo tee /etc/containerd/config.toml",
      "sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml",
      "systemctl restart containerd",
      "apt-get install -y kubelet kubeadm kubectl",
      "apt-mark hold kubelet kubeadm kubectl",
      "systemctl enable --now kubelet",
      "echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/k8s.conf",
      "sysctl --system",
      "kubeadm init --apiserver-advertise-address=${self.ipv4_address_private}  --apiserver-cert-extra-sans=${self.ipv4_address_private},${self.ipv4_address} --control-plane-endpoint=${self.ipv4_address} --node-name k8m1 --pod-network-cidr=10.244.0.0/16",
      "export KUBECONFIG=/etc/kubernetes/admin.conf",
      "mkdir -p /root/.kube && cp /etc/kubernetes/admin.conf /root/.kube/config",
      "curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/canal.yaml | kubectl apply -f -"
    ]
  }
 
}

resource "digitalocean_droplet" "k8w1" {
  image = "ubuntu-24-04-x64"
  name = "k8w1"
  region = "sfo3"
  size = "s-2vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.vtadmin.id
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg lsb-release",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y containerd && sudo systemctl enable containerd",
      "sudo mkdir /etc/containerd",
      "containerd config default | sudo tee /etc/containerd/config.toml",
      "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml",
      "sudo systemctl restart containerd",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable --now kubelet",
      "sudo echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/k8s.conf",
      "sysctl --system"
    ]
  }
}


resource "digitalocean_droplet" "k8w2" {
  image = "ubuntu-24-04-x64"
  name = "k8w2"
  region = "sfo3"
  size = "s-2vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.vtadmin.id
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg lsb-release",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y containerd && sudo systemctl enable containerd",
      "sudo mkdir /etc/containerd",
      "containerd config default | sudo tee /etc/containerd/config.toml",
      "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml",
      "sudo systemctl restart containerd",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable --now kubelet",
      "sudo echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/k8s.conf",
      "sysctl --system"
    ]
  }
}
output "master_ip_address" { value=digitalocean_droplet.k8m1.ipv4_address}
output "w1_ip_address" { value=digitalocean_droplet.k8w1.ipv4_address}
output "w2_ip_address" { value=digitalocean_droplet.k8w2.ipv4_address}
