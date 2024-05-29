
#######################################################################################################################################################
################ Configuration ############
#######################################################################################################################################################


sudo kubeadm config print init-defaults




kubectl config get-contexts



mkdir -p /nfs/RBAC/Support


cd /nfs/RBAC/Support


####Create User
sudo useradd -s /bin/bash Support

sudo passwd Support # password --> 123456789



# Generate a private key then Certificate Signing Request (CSR) forSupport

openssl genrsa -out Support.key 2048

touch $HOME/.rnd

openssl req -new -key Support.key -out Support.csr -subj "/CN=Support/O=Support"

sudo openssl x509 -req -in Support.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out Support.crt -days 3650



### We will now create a context
kubectl config set-context Support-context --cluster=kubernetes  --user=Support

#cp $HOME/.kube/config ./support-cluster-api-config
cp $HOME/.kube/config ./devops-cluster-api-config
cp ../Devops/devops-cluster-api-config ./support-cluster-api-config


chmod 777 -R /nfs/RBAC/ 

########### modify the config and Add the new user and certificates ###########

export KUBECONFIG=/nfs/RBAC/Support/support-cluster-api-config




kubectl config get-contexts


vi Support-ClusterRoleBinding.yaml

kubectl create -f Support-ClusterRoleBinding.yaml


kubectl --context=Support-context get pods


rm -f $HOME/.kube/config

cp ./support-cluster-api-config $HOME/.kube/config

kubectl config get-contexts

##################verification###################

kubectl --context=Support-context auth can-i delete svc
kubectl --context=Support-context auth can-i delete secret
kubectl --context=Support-context auth can-i delete pod


kubectl  auth can-i delete svc
kubectl  auth can-i delete secret
kubectl  auth can-i delete pod




