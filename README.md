# hostwiki
This repo is to host the code to host a wiki on k8s

MediaWIKI is a PHP app that needs to be hosted on a webserver (Apache?)
It also has a dependancy on the mysql db (mariadb?)

Pre-req:

Need Azure DevOps org setup with build agent.
Build agent should have the capability to unzip/Docker build
Azure Subscription with a service principal setup that has contributor access.
Setup Service connection with the Azure Subscription form ADO.
Setup Service connection with the Docker hub from ADO.
Setup Extension for Terraform in ADO.

Let's take a look at the files in this repo -

Dockerfile:

  This will get the latest php/apache image and load the mentioned wiki release on it.
  After that we also can copy the localsettings file to avoid the postinstall config.
  We build and push the container using this Dockerfile.

LocalSettings-aks.php:

  This file has the config that we have generated post install. We can reuse this file to avoid re-install config changes.

Azurepipelines/build.yaml:
  
  This is a build pipeline yaml file that we use with Azure DevOps to build and push the mediawiki image using Docker.
  Assuems that the service connection is available with build agent and Docker hub.

Azurepipelines/deploy.yaml:
  
  Deploys the newly built image to Azure AKS instance.
  Assumes that the AKS is up and running and also assumes the service connection to AKS.

infra/main: 
  
  Contains the TF code to create services/deployment/statefulset for mariadb and mediawiki installation.
  We expose the mediawiki deployment using LoadBalancer service.

infra/variables.tf: 
  
  Variables for the appId and it's password. This will later be used to provide access to AKS on the ACR that is created.

infra/Azurepipelines/buildInfra.yaml: 
  
  Build pipeline yaml for ADO. This will expect a service connection to Azure subscription. 
  This has two stages, one for the plan and other for deployment of resources.
  The pipeline requires Terraform extension to be installed in the ADO organisation.

k8s/mediawiki.yaml: 
  
  Contains all the k8s resources that we can use to deploy the app on AKS.
  This file is used by 'Azurepipelines/deploy.yaml' to deploy the app.

### TODO:
1. Use Helm charts for the deployment
2. Add manual approval for TF Apply stage.
3. Reduce hardcoding.
4. Use k8s secrets to hold env variables used.
5. Check how to use LocalSettings-aks.php





