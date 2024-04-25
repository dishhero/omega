
include ./.compose/local/utility/make_files/base.mk

# --------------------------------------------------- #
##@ Docker options:
.PHONY: docker_prune_all docker_build
docker_prune_all: ##@ (DOCKER) Erase all images, volumes and networks
	@docker system prune --all
	@docker volume rm `docker volume ls -q -f dangling=true`

docker_build: ##@ (DOCKER) Docker compose up
	@docker compose -f $(PATH_LOCAL)/local.yml build --parallel
	@docker compose -f $(PATH_LOCAL)/local.yml up --detach

# --------------------------------------------------- #
##@ Local options:
MANAGE_PY=$(VE_PYTHON) manage.py

.PHONY: local_install local_superuser local_update local_run
local_install: ##@ (LOCAL) Install project locally
	@sudo bash $(PATH_UTILS)/install/install_os_dependencies.sh install
	@make local_update
	@make docker_build

local_superuser:
	RUNNING_AS=dev $(MANAGE_PY) createsuperuserwithpassword \
	--username admin --password admin --email admin@omega.org --preserve

local_update: ##@ (LOCAL) update dependencies
	@source $(PATH_UTILS)/install/install_python_dependencies.sh

local_run: ##@ (LOCAL) Run Django server
	RUNNING_AS=dev $(MANAGE_PY) migrate;
	RUNNING_AS=dev $(MANAGE_PY) runserver 0.0.0.0:8000

local_precommit:
	pre-commit install; pre-commit run --all-files;
# --------------------------------------------------- #
