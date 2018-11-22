export DOCKER_TLS_VERIFY=1
export COMPOSE_TLS_VERSION=TLSv1_2
export DOCKER_CERT_PATH=$PWD
export DOCKER_HOST=tcp://ucp.andreas.dtcntr.net:443

if kubectl >/dev/null 2>&1; then
    unset KUBECONFIG
    kubectl config set-cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --server https://ucp.andreas.dtcntr.net:6443 --certificate-authority "$PWD/ca.pem" --embed-certs
    kubectl config set-credentials ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --client-key "$PWD/key.pem" --client-certificate "$PWD/cert.pem" --embed-certs
    kubectl config set-context ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --user ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline
fi
export KUBECONFIG=$PWD/kube.yml

#
# Bundle for user ci-pipeline
# UCP Instance ID 7dh6d6nv13w2f7au1i9tpvqhq
#
# Run this command from within this directory to configure your shell:
# eval "$(<env.sh)"
