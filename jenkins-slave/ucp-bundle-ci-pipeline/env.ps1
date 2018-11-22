$Env:DOCKER_TLS_VERIFY = 1
$Env:COMPOSE_TLS_VERSION = "TLSv1_2"
$Env:DOCKER_CERT_PATH = Split-Path $script:MyInvocation.MyCommand.Path
$Env:DOCKER_HOST = "tcp://ucp.andreas.dtcntr.net:443"

$d = Split-Path $script:MyInvocation.MyCommand.Path
if (Get-Command kubectl -ErrorAction Ignore) {
        $Env:KUBECONFIG = $null
        kubectl config set-cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --server https://ucp.andreas.dtcntr.net:6443 --certificate-authority "$(Join-Path $d ca.pem)" --embed-certs
        kubectl config set-credentials ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --client-key "$(Join-Path $d key.pem)" --client-certificate "$(Join-Path $d cert.pem)" --embed-certs
        kubectl config set-context ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --user ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline
}
$Env:KUBECONFIG = Join-Path $d kube.yml

#
# Bundle for user ci-pipeline
# UCP Instance ID 7dh6d6nv13w2f7au1i9tpvqhq
#
# Run this command from within this directory to configure your shell:
# Import-Module .\env.ps1
