FROM python:3

# Install curl
RUN apt-get update
RUN apt-get install -y curl

# Install kubectl 

# Set the Kubernetes version as found in the UCP Dashboard or API
RUN k8sversion=v1.15.5

# Get the kubectl binary.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$k8sversion/bin/linux/amd64/kubectl

# Make the kubectl binary executable.
RUN chmod +x ./kubectl

# Move the kubectl executable to /usr/local/bin.
RUN mv ./kubectl /usr/local/bin/kubectl


# Install kfctl

RUN curl -o kfctl_v1.0.0_linux.tar.gz -L0 https://github.com/kubeflow/kfctl/releases/download/v1.0/kfctl_v1.0-0-g94c35cf_linux.tar.gz
RUN tar -xvf kfctl_v1.0.0_linux.tar.gz
RUN mv ./kfctl /usr/local/bin/kfctl
RUN rm -rf kfctl_v1.0.0_linux.tar.gz


########################################
## Start AWS Installations
#######################################

# Run eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

# Install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
RUN echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# RUN AWS CLI
RUN pip install awscli
RUN apt-get install jq

# Copy Credentials
ADD credentials  ./root/.aws/credentials

####################################################

ADD config /root/.kube/config

