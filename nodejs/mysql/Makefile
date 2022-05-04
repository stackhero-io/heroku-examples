.DEFAULT_GOAL := help
.PHONY : help
SHELL=/bin/bash
CYAN := "\e[0;36m"
NC := "\e[0m"
INFO := @bash -c 'printf $(CYAN); echo "$$1"; printf $(NC)' MESSAGE

# Help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@sed -n 's/^## HELP://p' Makefile


checks:
# DYNO exists only on Heroku's dynos
ifndef DYNO
	@heroku -v > /dev/null 2>&1 || (echo "Heroku CLI should be installed on your computer" ; exit 1)
	@node -v > /dev/null 2>&1 || (echo "Node.js CLI should be installed on your computer" ; exit 1)
	@npm -v > /dev/null 2>&1 || (echo "NPM CLI should be installed on your computer" ; exit 1)
	@heroku addons:info ah-mysql-stackhero > /dev/null 2>&1 || (echo "You don't have a Stackhero for MySQL add-on running on this app" ; exit 1)
endif

init: checks
ifeq (,$(wildcard ./.initialized))
# DYNO exists only on Heroku's dynos
ifndef DYNO
	heroku config -s > .env
endif

	npm install

	touch .initialized
endif


run: init
	@echo "────────────────────────────────────────────────────────────────────────────────"
	@node src/app.js
	@echo "────────────────────────────────────────────────────────────────────────────────"


## HELP: local    : Run this app locally
local: init
	${INFO} "🚀 Running locally..."
# heroku local
# $(sed -ne 's/ *#.*$//; /./ p' .env | xargs) make run
	${INFO} "✅ Successfully ran locally!"


## HELP: remote   : Run this app remotely
remote:
	${INFO} "🚀 Running Remotely..."

	@[[ -z "${HEROKU_APP}" ]] \
		&& echo -e "\nYou should define the HEROKU_APP variable first.\nHere are your apps:\n\n`heroku apps`\n\nYou now have to run \"export HEROKU_APP=<your app name>\"" \
		&& exit 1

# The goal here is to create an archive with source files and upload it (using a hack with environment variables) to Heroku's Dyno.
# With this hack, we can run our test code on user's Dyno, without requiring him/her to create a dedicated app.
	@tar cfz stackhero-test.tar.bz2 src/ package.json Makefile
	@heroku run \
		-e test="`cat stackhero-test.tar.bz2 | base64 -w 0`" \
		'\
			rm -fr /tmp/stackhero-tests ; \
			mkdir -p /tmp/stackhero-tests ; \
			cd /tmp/stackhero-tests ; \
			echo $$test | base64 -d > stackhero-test.tar.bz2 ; \
			tar xfz stackhero-test.tar.bz2 ; \
			make run'
	${INFO} "✅ Successfully ran remotely!"
