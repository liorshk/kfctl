## This Docker makes it possible to run kubeflow on Docker Desktop for Windows (Kubernetes)
#### Works on Kubeflow 1.0.0
This project builds a Depend-on-Docker container for kfctl and kubectl

## Build and Run

#### Build the docker
- `docker build -t lior/kfctl .`

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
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_k8s_istio.v1.0.0.yaml"
export KF_NAME=localkf
export BASE_DIR=.
export KF_DIR=${BASE_DIR}/${KF_NAME}
mkdir -p ${KF_DIR}
cd ${KF_DIR}
kfctl apply -V -f ${CONFIG_URI}
```

#### Errors:
If you have the error `Encountered error applying application ...` then run 
- `kfctl apply -V -f kfctl_k8s_istio.v1.0.0.yaml`