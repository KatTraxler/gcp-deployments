## Binary Authorization TM Deployment
A GCP deployment that puts in place the infrastructure to build, sign, attest and push images to GKE.

## Inputs
- Complete the `TEMPLATE.tfvars` and rename to `terraform.tfvars`
    - project_id = ""
    - region     = ""  

## Deployment
1. From root directory
`terraform plan`
`terraform apply -auto-approve`
**Note:** the first deploy will take awhile (~3 minutes) as a Cloud Build trigger needs to run, deploying the binary authorization signing container.    

2. From ./sample-container directory
Push code to Source Repo
The first deployment only: 
    - `git init`
    - `git remote add origin https://source.developers.google.com/p/PROJECT_ID/r/kat-dummy-repo`
    - `git add .`
    - `git commit -m "initial commit"`
The first deployment and subsequent deployments:
    - `git push origin master`   

## Destroy
1. From root directory

`terraform destroy -auto-approve`

## Resources Created

1. Binary Authorization Attestors
   1. (2) attestors, one configured for manual signing, one integrated with KMS
2. Binary Authorization Policy
   1. (2) Policies, one basic and one with global evaluation
3. Container Analysis Notes
   1. (2) Notes, one for each attestor to write occurances
4. KMS Asymmetric Key 
   1. (1) Asymmetric key used by an attestor to sign images
5. Source Repo
   1. Stores helloworld sample Go app
6. Artifact Registry
   1. Stores both the helloworld sample Go app and the Binary Authorization Signing Container.
7. Cloud Build Trigger
   1. Used to build, push, sign and deploy the sample app
8. VPC
   1. Virtual network for the GKE cluster
9.  GKE Cluster
    1.  Deployment target the helloworld sample app
10.  Binary Authorization Signing Container (Google Community Container)
11. Helloworld Sample Go App
    1.  Directory with sample app files, cloudbuild.yaml file and Dockerfile

## Logging
