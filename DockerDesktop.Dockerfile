FROM python:3

# Install curl
RUN apt-get update
RUN apt-get install -y curl

# Install kubectl 

# Set the Kubernetes version as found in the UCP Dashboard or API
RUN k8sversion=v1.16.5

# Get the kubectl binary.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$k8sversion/bin/linux/amd64/kubectl

# Make the kubectl binary executable.
RUN chmod +x ./kubectl

# Move the kubectl executable to /usr/local/bin.
RUN mv ./kubectl /usr/local/bin/kubectl


# Install kfctl

RUN curl -o kfctl_v1.1.0_linux.tar.gz -L0 https://github.com/kubeflow/kfctl/releases/download/v1.1.0/kfctl_v1.1.0-0-g9a3621e_linux.tar.gz
RUN tar -xvf kfctl_v1.1.0_linux.tar.gz
RUN mv ./kfctl /usr/local/bin/kfctl
RUN rm -rf kfctl_v1.1.0_linux.tar.gz


ADD config /root/.kube/config

