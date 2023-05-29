#!/bin/bash

echo "This script will create a pull-secret in your current namespace, patch it to default serviceaccount and generate an SSH key in the ~/.ssh directory. Do you want to proceed? (y/n)"
read proceed

if [ "$proceed" != "y" ]; then
  echo "Cancelled script..."
  exit 1
fi

kubectl create secret docker-registry pull-secret \
    --docker-server=harbor.$DOMAIN \
    --docker-username=$DOCKER_USER \
    --docker-password=$DOCKER_PASSWORD

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'

ssh-keygen -t rsa -C "deploymentkey" -N "" -f ~/.ssh/argosshkey -q

echo Generated argosshkey in ~/.ssh
echo Done!