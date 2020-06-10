#!/bin/bash
DEFAULT_ZIP_PATH=`pwd`
DEFAULT_BUILD_SERVICE_VERSION=0.1.0
DEFAULT_REGISTRY=index.docker.io
DEFAULT_CLEANUP_CONTAINERS=true
DEFAULT_KUBECONFIG=$(eval echo "~$USER")/.kube/config

read -p "Enter Build service version [$DEFAULT_BUILD_SERVICE_VERSION]: " BUILD_SERVICE_VERSION
BUILD_SERVICE_VERSION=${BUILD_SERVICE_VERSION:-$DEFAULT_BUILD_SERVICE_VERSION}

read -p "Enter path for build service [$DEFAULT_ZIP_PATH]: " BUILD_ZIP_PATH
BUILD_ZIP_PATH=${BUILD_ZIP_PATH:-$DEFAULT_ZIP_PATH}

read -p "Enter docker server [$DEFAULT_REGISTRY]: " REGISTRY
REGISTRY=${REGISTRY:-$DEFAULT_REGISTRY}

read -p "Enter registry user: " REGISTRY_USER

read -p "Clean up containers? [$DEFAULT_CLEANUP_CONTAINERS]: " CLEANUP_CONTAINERS
CLEANUP_CONTAINERS=${CLEANUP_CONTAINERS:-$DEFAULT_CLEANUP_CONTAINERS}

read -p "Kubeconfig path [$DEFAULT_KUBECONFIG]: " BUILD_KUBECONFIG
BUILD_KUBECONFIG=${BUILD_KUBECONFIG:-$DEFAULT_KUBECONFIG}

read -p "Enter kubernetes cluster name: " KUBERNETES_CLUSTER


read -p "If cluster is PSP enabled please provide privillage role name: " PSP_ROLE_NAME
PSP_ROLE_NAME=${PSP_ROLE_NAME} 

echo "Uploading build images to registry will take time. Please wait until it completes"
duffle relocate -f $BUILD_ZIP_PATH/build-service-$BUILD_SERVICE_VERSION.tgz -m $DEFAULT_ZIP_PATH/relocated.json -p $REGISTRY_USER

echo "Registry upload complete. Installing duffle"

if [ ! -z $PSP_ROLE_NAME ]
then
cat <<EOF > $BUILD_ZIP_PATH/psp.yml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: build-privileged-cluster-role-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: "$PSP_ROLE_NAME"
    subjects:
    - kind: ServiceAccount
      name: default
      namespace: project-operator 
EOF
echo "Apply cluster role binding"
kubectl apply -f $BUILD_ZIP_PATH/psp.yml
fi


cat <<EOF > $BUILD_ZIP_PATH/credentials.yml
name: build-service-credentials
credentials:
 - name: kube_config
   source:
     path: "/tmp/kube/k8s-tbsautomation-default-conf"
   destination:
     path: "$BUILD_KUBECONFIG"
EOF

cat $BUILD_ZIP_PATH/credentials.yml


COUNT=$(duffle list -s|grep tanzu-build-service|wc -l | xargs)
if [ $COUNT == 1 ]
then
   echo "Installation bundle already exists with the name. Please uninstall or use upgrade option (Future)"
else
   duffle install tanzu-build-service -c $BUILD_ZIP_PATH/credentials.yml  \
    --set kubernetes_env=$KUBERNETES_CLUSTER \
    --set docker_registry=$REGISTRY \
    --set docker_repository=$REGISTRY/$REGISTRY_USER \
    --set registry_username=$REGISTRY_USER \
    --set registry_password=$REGISTRY_TOKEN \
    --set custom_builder_image="$REGISTRY_USER/tanzu-builder" \
    -f $BUILD_ZIP_PATH/build-service-$BUILD_SERVICE_VERSION.tgz \
    -m $BUILD_ZIP_PATH/relocated.json
fi

