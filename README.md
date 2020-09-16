## This Docker makes it possible to run kubeflow on Docker Desktop for Windows (Kubernetes)
#### Works on Kubeflow 1.0.0
This project builds a Depend-on-Docker container for kfctl and kubectl

## Build and Run

#### Build the docker
- `docker build -t lior/kfctl -f DockerDesktop.Dockerfile .`

#### Copy .kube/config to /root/.kube/config and Run the docker
There are multiple ways to do that:
- Mount your local .kube directory onto /root/.kube
Replace `~/.kube/` with the path of your config (on windows it's on `%USERPROFILE%/.kube`).  Make sure you are able to share the directory (Docker -> Resources -> File sharing)
  - `docker run --rm -v ~/.kube/:/root/.kube/ -it lior/kfctl bash`

- Copy the config to this directory and build the docker with: `ADD config /root/.kube/config`
  - `docker run --rm -it lior/kfctl bash`

#### Then run kubeflow
Like described here: https://www.kubeflow.org/docs/started/k8s/kfctl-k8s-istio/
```
export KFAPP=localkf
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.1-branch/kfdef/kfctl_k8s_istio.v1.1.0.yaml"
export KF_NAME=localkf
export BASE_DIR=.
export KF_DIR=${BASE_DIR}/${KF_NAME}
mkdir -p ${KF_DIR}
cd ${KF_DIR}
kfctl apply -V -f ${CONFIG_URI}
```


#### Errors:
If you have the error `Encountered error applying application cert-manager...` then run 
- `kfctl apply -V -f kfctl_k8s_istio.v1.1.0.yaml`


--------------------------
## Deploying to AWS from Windows (using a docker)

### Build and Run

#### Build the docker 
- `docker build -t lior/kfctl -f AWS.Dockerfile .`

#### Run the docker to start connecting to the cluster
- `docker run -it lior/kfctl bash`


#### Get Region and Roles and save as AWS_ROLE_NAME
Retrieve the AWS Region and IAM role name for your worker nodes. To get the IAM role name for your Amazon EKS worker node, run the following command:
```
export AWS_ROLE_NAME=$(aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-$AWS_CLUSTER_NAME\") and contains(\"NodeInstanceRole\")) \
    .RoleName")
```

#### In the docker, run the following:
```
# Use the following kfctl configuration file for the standard AWS setup:
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_aws.v1.0.0.yaml"

# Set an environment variable for your AWS cluster name, and set the name
# of the Kubeflow deployment to the same as the cluster name.
export AWS_CLUSTER_NAME=kf
export KF_NAME=${AWS_CLUSTER_NAME}

# Set the path to the base directory where you want to store one or more
# Kubeflow deployments. For example, /opt/.
# Then set the Kubeflow application directory for this deployment.
export BASE_DIR=/opt/
export KF_DIR=${BASE_DIR}/${KF_NAME}

mkdir -p ${KF_DIR}
cd ${KF_DIR}
curl -o kfctl_aws.yaml -L0 $CONFIG_URI
export CONFIG_FILE=${KF_DIR}/kfctl_aws.yaml

sed -i'.bak' -e 's/kubeflow-aws/'"$AWS_CLUSTER_NAME"'/' ${CONFIG_FILE}

sed -i 's/eksctl-kf-nodegroup-ng-a2-NodeInstanceRole-xxxxx/'"$AWS_ROLE_NAME"'/g' ${CONFIG_FILE}

```

### Finally deploy kubeflow
`kfctl apply -V -f ${CONFIG_FILE}`

### Get the url
`kubectl get ingress -n istio-system`
