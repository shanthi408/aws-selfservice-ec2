
## Dependencies
- GNU make, 4.3. For MACOS, you can install with brew install make. And make sure /usr/local/opt/make/libexec/gnubin is in PATH 
```
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
```
- terraform v0.12+
- aws cli V2.0+
- jq

## pre-requsities
1) export AWS_PROFILE=

2) update values in terraform.tfvars

3) 
create s3 and dynamodb tables

S3_BUCKET="abc-343-$(ENV)-$(REGION)-167-terraform"
DYNAMODB_TABLE="abc-343-$(ENV)-$(REGION)-167-terraform"

The above values are defined in Makefile



## Commands
```
- please check these varaible S3_BUCKET & APP_NAME values in Makefile before executing

- example environment=sandbox; region=us-east-1

- $ENV=dev REGION=us-east-1 make prep
- $ENV=dev REGION=us-east-1 make plan
- $ENV=dev REGION=us-east-1 make apply
- $ENV=dev REGION=us-east-1 make destroy
```

