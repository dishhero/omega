export REQ_PYTHON = 3.12.3
export REQ_VENV = omega
export PROJ_ROOT = $(shell pwd)

# remove Leaving/Entering directory message
MAKEFLAGS += --no-print-directory
SHELL:=/bin/bash
# ------------------------------- #
PATH_LOCAL := $(PROJ_ROOT)/.compose/local
PATH_UTILS := $(PATH_LOCAL)/utility
# ------------------------------- #
VE_PYTHON := $(shell pyenv root)/versions/$(REQ_PYTHON)/envs/$(REQ_VENV)/bin/python3

# .PHONY: help
# .DEFAULT_GOAL := help
# # make help or make --- for output headers functions
# help : Makefile
# 	@clear
# 	@echo '############## DOCKER UTILS ################'
# 	@sed -n 's/^#_du //p' $(PATH_UTILS)/make_files/docker_db.mk
# 	@sed -n 's/^#_du //p' ./Makefile
# 	@echo ' ' && echo '############## POSTGRESS ###################'
# 	@sed -n 's/^#_db //p' $(PATH_UTILS)/make_files/docker_db.mk
# 	@echo ' ' && echo '############## DB DUMPS ####################'
# 	@sed -n 's/^#_dump //p' $(PATH_UTILS)/make_files/docker_db.mk
# 	@echo ' ' && echo '############## DB LOAD #####################'
# 	@sed -n 's/^#_dbload //p' ./Makefile
# 	@echo ' ' && echo '############## TESTS #######################'
# 	@sed -n 's/^#_tests //p' $(PATH_UTILS)/make_files/tests.mk
# 	@sed -n 's/^#_tests //p' ./Makefile
# # 	final spacing
# 	@echo ' '

# --------------------------------
AWK := awk
ifeq ($(shell uname -s), Darwin)
	AWK = gawk
    ifeq (, $(shell which gawk 2> /dev/null))
        $(error "gawk not found")
    endif
endif
help: 
	@printf "Usage: make <command>\n"
	@grep -F -h "##@" $(MAKEFILE_LIST) | grep -F -v grep -F | sed -e 's/\\$$//' | $(AWK) 'BEGIN {FS = ":*[[:space:]]*##@[[:space:]]*"}; \
	{ \
		if($$2 == "") \
			pass; \
		else if($$0 ~ /^#/) \
			printf "\n%s", $$2; \
		else if($$1 == "") \
			printf "   %-20s%s", "", $$2; \
		else \
			printf "\n  \033[34m%-20s\033[0m %s", $$1, $$2; \
	}'
	@printf "\n"
# --------------------------------