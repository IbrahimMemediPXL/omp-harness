.DEFAULT_GOAL := help
.PHONY: help init login logout safe normal yolo doctor version profiles validate

help: ## Show commands (run inside the Dev Container)
	@awk 'BEGIN {FS = ":.*## "; print "OMP Harness commands:"} /^[a-zA-Z_-]+:.*## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize directories and optional .env
	@bash .devcontainer/post-create.sh

login: ## Open SAFE OMP; enter /login openai-codex
	@printf '%s\n' 'In OMP enter: /login openai-codex. Choose your Business workspace in the browser.'
	@bash .devcontainer/omp-safe

logout: ## Open SAFE OMP; enter /logout and select the provider
	@printf '%s\n' 'In OMP enter /logout and select the provider. Sessions and volume are kept.'
	@bash .devcontainer/omp-safe

safe: ## Prompt for writes and execution
	@bash .devcontainer/omp-safe $(ARGS)

normal: ## Allow edits; prompt for bash, eval, delete and move
	@bash .devcontainer/omp-normal $(ARGS)

yolo: ## Reduce approvals (not a stronger sandbox)
	@printf '%s\n' 'WARNING: YOLO reduces approvals. Workspace and credentials remain exposed to container processes.'
	@bash .devcontainer/omp-yolo $(ARGS)

doctor: ## Run container checks (does not validate OAuth)
	@bash .devcontainer/doctor.sh

version: ## Print installed OMP version
	@omp --version

profiles: ## Print effective approval modes
	@set -e; for profile in safe normal yolo; do \
	  printf '%s: ' "$$profile"; \
	  omp --config ".omp/profiles/$$profile.yml" config get tools.approvalMode; \
	done

validate: ## Run static checks without model credentials
	@python3 scripts/validate.py
