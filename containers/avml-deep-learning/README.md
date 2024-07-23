# AVML Deep Learning Container

A docker container using the Google-provided Deep Learning COS as a base with AVML tooling installed on top. The container is built remotely with Cloudbuild and published to Artifact Registry.

## Installations

### Terraform Installation

This deployment has been tested and verified with Terraform version `1.8.0`.  To manage multiple versions of Terraform on your system, install `tfenv` command line tool, allowing you to switch between different versions of Terraform. 

1. Install `tfenv`

``` bash
brew install tfenv
``` 

2. Install Terraform version 1.8.0

``` bash
tfenv install 1.8.0
```

3. Set version 1.8.0 as your default version

``` bash
tfenv use 1.8.0
```    


### gcloud SDK Installation
1. Ensure the Google command line tool is installed locally.  Reference Google maintained [documentation](https://cloud.google.com/sdk/docs/install) for instructions on installing `gcloud cli`
2. Authenticate to Google Cloud Project you're deploying these resources.
```
gcloud auth login --project PROJECT_ID
```


## Deploy and Build

### Authenticate to GCP
```bash
$ gcloud auth login --update-adc 
```


### Complete variables file:
Using the `TEMPLATE.tfvars` file as a guide, create a `./containers/avml-deep-learning/terraform.tfvars` file with the following values:
```bash
project_id = ""
zone = ""
region  = ""
```



### Deploy Resources: Build Container and push to Artifact Registry
```bash
$ cd ./containers/avml-deep-learning
$ terraform plan
$ terraform apply
```


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)