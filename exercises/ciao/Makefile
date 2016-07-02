REPOSITORY = realestate/ciao
VERSION := $(shell TZ=Australia/Melbourne date +'%Y%m%d%H%M')

image:
	docker build -t $(REPOSITORY):latest .

release: image
	docker tag $(REPOSITORY):latest $(REPOSITORY):$(VERSION)
	docker push $(REPOSITORY):latest
	docker push $(REPOSITORY):$(VERSION)
