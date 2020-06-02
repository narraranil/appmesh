#!/bin/sh
#

#cd /opt/rancher
#./rancher login https://k8s.eur.ad.sag/v3 --token token-vzcht:b6drnslrqsf2cnwnxr8jxp572zqkj4fl5hzxjq94tgl22qh4xdq2r9
#./rancher login https://k8s.eur.ad.sag/v3 --token token-k72zj:pbdbzjfxnr8ck4ffq7pgv2d8mb55krmnx26v4rm2qglgxb22h2kz2g
#./rancher kubectl create -f ${WORKSPACE}/PushCustomerImageToAKSK8.yaml
az login --service-principal -u 'http://ServicePrincipalName' -p '7b8d4a4a-320e-4cf2-b0f1-5ca00439d35c' --tenant '74d377a9-6eea-4db3-8d93-b2c8d9804e41'
az aks get-credentials --resource-group azure-k8stest --name k8stest
#./rancher kubectl replace -f ${WORKSPACE}/PushCustomerImageToK8.yaml
kubectl create -f ${WORKSPACE}/PushCustomerImageToAKSK8.yaml 

