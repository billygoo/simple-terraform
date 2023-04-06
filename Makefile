.PHONY: check
## check: check terraform files
check:
	docker run --rm -v $$(pwd):/data -w /data hashicorp/terraform:1.4.4 fmt -recursive -check -diff

.PHONY: format
## format: format terraform files
format:
	docker run --rm -v $$(pwd):/data -w /data hashicorp/terraform:1.4.4 fmt -recursive

.PHONY: help
## help: prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':'
