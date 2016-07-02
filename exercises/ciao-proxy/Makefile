REPOSITORY = realestate/ciao-proxy
VERSION := $(shell TZ=Australia/Melbourne date +'%Y%m%d%H%M')

default: image

image:
	docker build -t $(REPOSITORY) .

release: image
	docker tag $(REPOSITORY):latest $(REPOSITORY):$(VERSION)
	docker push $(REPOSITORY):latest
	docker push $(REPOSITORY):$(VERSION)
