REPO = mast3rm1lk/adminer-autologin
ADMINER_VERSION=5.3.0
ADMINER_FLAVOUR=-en

TAG=$(ADMINER_VERSION)$(ADMINER_FLAVOUR)

.PHONY: all build publish

all: build publish latest

build:
	docker build \
		--build-arg ADMINER_VERSION=$(ADMINER_VERSION) \
		--build-arg ADMINER_FLAVOUR=$(ADMINER_FLAVOUR) \
		-t $(REPO):$(TAG) \
		src

publish:
	docker push $(REPO):$(TAG)

latest:
	docker tag $(REPO):$(TAG) $(REPO):latest
	docker push $(REPO):latest

