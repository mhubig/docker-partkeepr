ORG     := mhubig
APP     := partkeepr
NAME    := $(ORG)/$(APP)
BRANCH  := $(shell git rev-parse --abbrev-ref HEAD)
VERSION := $(shell git describe)

.PHONY: all build tag push list run test inspect stop rm

all: build

build:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION);\
	then                                                                      \
		docker build -t $(NAME):$(VERSION) --rm .;                            \
	else                                                                      \
		true;                                                                 \
	fi

tag: build
	@if  [ $(BRANCH) = 'master' ];                     \
	then                                               \
		docker tag $(NAME):$(VERSION) $(NAME):latest;  \
	elif [ $(BRANCH) = 'develop' ];                    \
	then                                               \
		docker tag $(NAME):$(VERSION) $(NAME):develop; \
	fi

push: tag
	docker push $(NAME)

list:
	docker images $(NAME)

run:
	docker run -d -p 22 -p 80:80 --name $(APP) $(NAME):$(VERSION)

test: build
	docker run -d -p 8080:80 --name $(APP) $(NAME):$(VERSION)
	@echo 'To access the container run this command to forward the ports:'
	@echo '$ boot2docker ssh -L 8080:localhost:8080'

inspect: build
	docker run -t -i -p 8080:80 --rm $(NAME):$(VERSION) \
		/sbin/my_init -- bash -l

stop:
	docker stop $(APP)

rm:
	docker rm $(APP)
