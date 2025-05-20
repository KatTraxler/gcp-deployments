#! /bin/bash
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

# destroy resources with terraform
cd modules/terraform
terraform destroy -var region=$REGION -var zone=$ZONE -var project-id=$PROJECT -auto-approve
cd ../../
