# Terraform + Google Cloud Run + + Cloud Build + FastAPI

This repository showcases how to deploy an API created with FastAPI to Cloud Run (GCP) using Terraform and Cloud Build.

The folder `api` contains the API built with python and FastAPI. The respective tests are under the folder `tests`. 
To run the API create a virtual environment and install the dependencies with:

`pip install -r requirements.txt`
or
`poetry install`

Once inside the virtual environment, you can run the api using the command:
`python api/main.py`

## Deploying the service and infrastructure

First you need to have the proper permissions. In your GCP project, head over to IAM & Admin > Service Accounts and create a service account with the name terraform.

Then, navigate to IAM & Admin > IAM (link) and grant your service account the following permissions:

Editor
Artifact Registry Administrator
Cloud Run Admin
Project IAM Admin
Service Usage Admin

Export the service account keys and run the following command:
`export GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json`

Then move to the `infra` folder with `cd infra`.

Run `terraform init` to download the necessary plugins.

And finally, run the following command to create the infrastructure and services.

```terraform plan -var="project_id=your_project_name" -out terraform.plan && terraform apply "terraform.plan"```

Run `terraform destroy` to destroy the infrastructure and take the service down.