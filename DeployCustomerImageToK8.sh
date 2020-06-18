#!/bin/sh
#

cd /opt/rancher
#./rancher login https://k8s.eur.ad.sag/v3 --token token-vzcht:b6drnslrqsf2cnwnxr8jxp572zqkj4fl5hzxjq94tgl22qh4xdq2r9
./rancher login https://k8s.eur.ad.sag/v3 --token token-qblmm:q4x9k8jbjpvdhgkp6bqj9k9w2wlrgstdzpr5fnt5z8bh6tc9gqfbmf
#./rancher kubectl create -f ${WORKSPACE}/PushCustomerImageToK8.yaml 
./rancher kubectl replace -f ${WORKSPACE}/JenkinsDeployCustToAppMesh.yaml 

