#!/usr/bin/env make
# vim: tabstop=8 noexpandtab
#SHELL += -xue

tf-init:
	if [ ! -d '.terraform' ]; then \
		printf '\n%s\n' 'Initializing the build...'; \
		terraform init -get=true; \
	else \
		printf '\n%s\n\n' '  Dude, already initialized!'; \
	fi


tf-plan:
	terraform plan -var-file=local.tfvars \
		-out=kubes.plan 

tf-build:
	terraform apply kubes.plan 
