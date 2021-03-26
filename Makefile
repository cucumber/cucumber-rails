MONOREPO_PATH ?= ../../cucumber

# https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
RUBY_FILES=$(call rwildcard,../lib ../../cucumber-ruby-core/lib/,*.rb)

FEATURES = $(sort $(wildcard features/**.feature))

OS := $(shell [[ "$$(uname)" == "Darwin" ]] && echo "darwin" || echo "linux")
# Determine if we're on 386 or amd64 (ignoring other processors as we're not building on them)
ARCH := $(shell [[ "$$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "386")

bin/json-formatter: $(MONOREPO_PATH)/json-formatter/go/dist/cucumber-json-formatter-$(OS)-$(ARCH)
	cp $(MONOREPO_PATH)/json-formatter/go/dist/cucumber-json-formatter-$(OS)-$(ARCH) $@
	chmod +x $@

clean:
	rm -rf acceptance/*.json bin/json-formatter
.PHONY: clean

release:
	[ -d '../secrets' ]  || git clone keybase://team/cucumberbdd/secrets ../secrets
	git -C ../secrets pull
	../secrets/update_permissions
	docker run \
		--volume "${shell pwd}":/app \
		--volume "${shell pwd}/../secrets/import-gpg-key.sh":/home/cukebot/import-gpg-key.sh \
		--volume "${shell pwd}/../secrets/codesigning.key":/home/cukebot/codesigning.key \
		--volume "${shell pwd}/../secrets/.ssh":/home/cukebot/.ssh \
		--volume "${shell pwd}/../secrets/.gem":/home/cukebot/.gem \
		--volume "${HOME}/.gitconfig":/home/cukebot/.gitconfig \
		--env CUCUMBER_USE_RELEASED_GEMS=1 \
		--env-file ../secrets/secrets.list \
		--user 1000 \
		--rm \
		-it cucumber/cucumber-build:latest \
		bash -c "rm Gemfile.lock && bundle && bundle exec rake && bundle exec rake release"
.PHONY: release
