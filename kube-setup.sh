#!/usr/bin/env bash

a=`which kubectl`

haskubectl=$?

if [ $haskubectl -ne 0 ]; then
  echo "ERROR: Could not find kubectl in your path!"
  exit $haskubectl
fi

a=`which terraform`

hasterraform=$?

if [ $hasterraform -ne 0 ]; then
  echo "ERROR: Could not find terraform in your path!"
  exit $hasterraform
fi

updatedtf=`grep "CHANGEME" terraform/setup.tf | wc -l`
if [ $updatedtf -gt 0 ]; then
  echo "ERROR: Please update terraform/setup.tf"
  exit 1
fi

echo "Preparing to run terraform to setup stack... ctrl+c to exit now"
sleep 5

echo "This will take approx 10min to setup"

(cd terraform; terraform apply)

if [ $? -gt 0 ]; then
  echo "ERROR: terraform apply errored out"
  exit 1
fi

echo "Installing the guestbook now..."

echo -n "[Deployment] Redis-Master"
kubectl apply -f manifest/redis-master-deployment.yaml

i=0
while [ `kubectl get pods | grep Running | wc -l` -lt 1 ]
do
  if [ $i -gt 36 ];
  then 
    echo "ERROR: Could not get Redis-Master to start... we waited 3min"
    exit 1
  fi
  echo -n "."
  sleep 5
  i=$i + 1
done
echo " Done!"

echo "[Service] Redis-Master"
kubectl apply -f manifest/redis-master-service.yaml

echo "[Deployment] Redis-Slave"
kubectl apply -f manifest/redis-slave-deployment.yaml
echo "[Service] Redis-Slave"
kubectl apply -f manifest/redis-slave-service.yaml

echo "[Deployment] Frontend"
kubectl apply -f manifest/frontend-deployment.yaml
echo "[Service] Frontend"

kubectl apply -f manifest/frontend-service.yaml

echo "You can view your guestbook at: "
sleep 10
hostname=`kubectl get service frontend -o=custom-columns=Hostname:.status.loadBalancer.ingress[].hostname --no-headers=true`
echo "http://$hostname"


