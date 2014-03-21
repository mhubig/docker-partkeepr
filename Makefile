ORG     := mhubig
APP     := partkeepr
NAME    := $(ORG)/$(APP)
VERSION := 0.1.9

.PHONY: all build tag push list run stop

all: build

build:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); \
	then                                                                       \
		docker build -t $(NAME):$(VERSION) --rm .;                             \
	else                                                                       \
		true;                                                                  \
	fi

tag: build
	docker tag $(NAME):$(VERSION) $(NAME):latest;

push: tag
	docker push $(NAME)

list:
	docker images $(NAME)

run:
	docker run -d -p 22 -p 80:80 --name $(APP) $(NAME):$(VERSION)

test:
	docker run -d -p 8022:22 -p 8080:80 --name $(APP) $(NAME):$(VERSION)
	@echo 'To access the container run this command to forward the ports:'
	@echo '$ boot2docker ssh -L 8080:localhost:8080 -L 8022:localhost:8022'

stop:
	docker stop $(APP)

rm:
	docker rm $(APP)
