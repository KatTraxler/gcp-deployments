#!/bin/bash

export PROJECT=$(gcloud config get-value project)
export REGION=us-central1
export ZONE=us-central1-a

echo "##########################################################"
echo "> Beginning terraform setup - glcoud config is:"
echo "##########################################################"

echo "PROJECT=$PROJECT"
echo "REGION=$REGION"
echo "ZONE=$ZONE"


echo "##########################################################"
echo "> Setting up GCP APIs and settings"
echo "##########################################################"
gcloud services enable logging.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com


# set up resources with terraform
echo "##########################################################"
echo "> Setting up terraform resources"
echo "##########################################################"

cd modules/terraform
if [[ ! -e /tf.out ]]; then
    touch tf.out
fi
terraform init -input=false
terraform plan -out tf.out -var region=$REGION -var zone=$ZONE -var project-id=$PROJECT -input=false
terraform apply -input=false "tf.out"
cd ../../