
TANZU BUILD SERVICE

Create service account-> To kube config
/tmp/kube/k8s-tbsautomation-default-conf

PSP name: vmware-system-tmc-psp-privileged


https://network.pivotal.io/products/build-service
1. Build pack build-service-0.1.0.tgz 
2. Duffle to install build service
3. build service cli 

Currently supported languages 
1. Java 
2. NodeJS 
3. .NET Core 
4. Python 
5. Golang 
6. PHP 
7. HTTPD 
8. NGINX 

Six steps process
1. prepare - Checks out repo from github
2. detect  - Identifies which build pack. If nothig matches fails.
3. analyze - Check prev builds & also cache
4. restore - Depends on step 3
5. build - Actual build is run here
6. export - Pushes to the registry


pb project create ecommerce 
pb project target ecommerce 

pb secrets registry apply -f ecommerce-registry.yaml  
pb secrets git apply -f  ecommerce-repo.yaml 

Deploy the 3 types of images - Github Branch, Commit id, Blob, and apply each and talk about it
