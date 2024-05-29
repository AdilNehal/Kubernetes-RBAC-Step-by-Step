
#######################################################################################################################################################
################ Configuration ############
#######################################################################################################################################################


cp $HOME/.kube/config ./cluster-api-config

sudo kubeadm config print init-defaults

kubectl config get-contexts

mkdir -p /nfs/RBAC/test
mkdir -p /home/RBAC/test && cd /home/RBAC/test


cd /nfs/RBAC/test

## Already done

####Create User
sudo useradd -s /bin/bash test

sudo passwd test # password --> 123456789


# Generate a private key then Certificate Signing Request (CSR) for test

openssl genrsa -out test.key 2048

touch $HOME/.rnd

openssl req -new -key test.key -out test.csr -subj "/CN=test/O=test"

sudo openssl x509 -req -in test.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out test.crt -days 3650


### We will now create a context
kubectl config set-context test-context --cluster=kubernetes --user=test

cp $HOME/.kube/config ./test-cluster-api-config

chmod 777 -R /nfs/RBAC/ 

########### modify the config and Add the new user and certificates ###########

export KUBECONFIG=/nfs/RBAC/test/test-cluster-api-config
export KUBECONFIG=/home/RBAC//test-cluster-api-config



kubectl config get-contexts


vi test-ClusterRoleBinding.yaml

kubectl create -f test-ClusterRoleBinding.yaml


kubectl --context=test-context get pods


rm -f $HOME/.kube/config

cp ./test-cluster-api-config  $HOME/.kube/config



##################verification###################

kubectl --context=test-context auth can-i delete svc
kubectl --context=test-context auth can-i delete secretx
kubectl --context=test-context auth can-i delete pod


kubectl  auth can-i delete svc
kubectl  auth can-i delete secret
kubectl  auth can-i delete pod



