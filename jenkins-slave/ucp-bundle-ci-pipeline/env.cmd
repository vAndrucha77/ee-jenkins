@echo off
set DOCKER_TLS_VERIFY=1
set COMPOSE_TLS_VERSION=TLSv1_2
set DOCKER_CERT_PATH=%~dp0
set DOCKER_HOST=tcp://ucp.andreas.dtcntr.net:443

kubectl >nul 2>&1
if %ERRORLEVEL% == 0 (
    set KUBECONFIG=
    kubectl config set-cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --server https://ucp.andreas.dtcntr.net:6443 --certificate-authority "%~dp0ca.pem" --embed-certs
    kubectl config set-credentials ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --client-key "%~dp0key.pem" --client-certificate "%~dp0cert.pem" --embed-certs
    kubectl config set-context ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --user ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline --cluster ucp_ucp.andreas.dtcntr.net:6443_ci-pipeline
)
set KUBECONFIG=%~dp0kube.yml

REM
REM Bundle for user ci-pipeline
REM UCP Instance ID 7dh6d6nv13w2f7au1i9tpvqhq
REM
REM Run this command from within this directory to configure your shell:
REM .\env.cmd
