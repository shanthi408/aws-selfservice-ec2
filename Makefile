.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy-backend destroy destroy-target plan-destroy plan plan-target prep
VARS="variables/$(ENV)-$(REGION).tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
APP_NAME="$(APP)"
S3_BUCKET="abc-343-$(ENV)-$(REGION)-167-terraform"
DYNAMODB_TABLE="abc-343-$(ENV)-$(REGION)-167-terraform"
WORKSPACE="ec2-$(ENV)-$(REGION)"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ENV) ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(AWS_PROFILE) ]; then \
		echo "$(BOLD)$(RED)AWS_PROFILE was not set.$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=whatever ENV=demo REGION=us-east-2 make plan\`$(RESET)"; \
		exit 1; \
	 fi

prep: set-env ## Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	@pwd
	@echo "$(BOLD)Configuring the terraform backend$(RESET)"
	@echo "$(APP_NAME)"
	@terraform init \
		-input=false \
		-force-copy \
		-lock=true \
		-verify-plugins=true \
		-backend=true \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="region=$(REGION)" \
		-backend-config="bucket=$(S3_BUCKET)" \
		-backend-config="key=$(APP_NAME)/ec2.tfstate" \
		-backend-config="dynamodb_table=$(DYNAMODB_TABLE)"\
	    -backend-config="acl=private"
	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

plan: prep ## Show what terraform thinks it will do
	@terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-var='ec2securitygroups=["sg-dea4b0da"]' \
		-var='autoscalinggroupsubnets=["subnet-78eb921e","subnet-7380c752"]' \
		-var='tags={"Name":"dev_ec2","Created_By":"Shanthi","Created_Date":"5/26/2021","Organization":"CSO","Owner":"JohnDoe","Project":"SelfServiceEC2","Environment":"Dev","Jira_ticket_Number":"CICD-2021","Expires":"12/12/2021","OS":"Ubuntu"}'

plan-target: prep ## Shows what a plan looks like for applying a specific resource
	@echo "$(YELLOW)$(BOLD)[INFO]   $(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "PLAN target: " DATA && \
		terraform plan \
			-lock=true \
			-input=true \
			-refresh=true \
			-target=$$DATA \
			-var='ec2securitygroups=["sg-dea4b0da"]' \
			-var='autoscalinggroupsubnets=["subnet-78eb921e","subnet-7380c752"]' \
			-var='tags={"Name":"dev_ec2","Created_By":"Shanthi","Created_Date":"5/26/2021","Organization":"CSO","Owner":"JohnDoe","Project":"SelfServiceEC2","Environment":"Dev","Jira_ticket_Number":"CICD-2021","Expires":"12/12/2021","OS":"Ubuntu"}'

plan-destroy: prep ## Creates a destruction plan.
	@terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-var='ec2securitygroups=["sg-dea4b0da"]' \
		-var='autoscalinggroupsubnets=["subnet-78eb921e","subnet-7380c752"]' \
		-var='tags={"Name":"dev_ec2","Created_By":"Shanthi","Created_Date":"5/26/2021","Organization":"CSO","Owner":"JohnDoe","Project":"SelfServiceEC2","Environment":"Dev","Jira_ticket_Number":"CICD-2021","Expires":"12/12/2021","OS":"Ubuntu"}'


apply: prep ## terraform apply
	@terraform apply \
		-lock=true \
		-input=false \
		-refresh=true \
		-auto-approve=true \
		-var='ec2securitygroups=["sg-dea4b0da"]' \
		-var='autoscalinggroupsubnets=["subnet-78eb921e","subnet-7380c752"]' \
		-var='tags={"Name":"dev_ec2","Created_By":"Shanthi","Created_Date":"5/26/2021","Organization":"CSO","Owner":"JohnDoe","Project":"SelfServiceEC2","Environment":"Dev","Jira_ticket_Number":"CICD-2021","Expires":"12/12/2021","OS":"Ubuntu"}'

destroy: prep ## Destroy the resources
	@terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-auto-approve=true \
		-var='ec2securitygroups=["sg-dea4b0da"]' \
		-var='autoscalinggroupsubnets=["subnet-78eb921e","subnet-7380c752"]' \
        -var='tags={"Name":"dev_ec2","Created_By":"Shanthi","Created_Date":"5/26/2021","Organization":"CSO","Owner":"JohnDoe","Project":"SelfServiceEC2","Environment":"Dev","Jira_ticket_Number":"CICD-2021","Expires":"12/12/2021","OS":"Ubuntu"}'
