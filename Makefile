ORG     := mhubig
APP     := partkeepr
NAME    := $(ORG)/$(APP)
BRANCH  := $(shell git rev-parse --abbrev-ref HEAD)
VERSION := $(shell git describe)

.PHONY: all build tag push list run test inspect stop rm

all: build

build:
	@if ! docker images $(NAME) | awk '{ print $$2 }' |	\
		grep -q -F $(VERSION);							\
	then												\
		docker build -t $(NAME):$(VERSION) --rm .;		\
	else												\
		true;											\
	fi

tag: build
	@if [ $(BRANCH) = 'master' ];						\
	then												\
		docker tag $(NAME):$(VERSION) $(NAME):latest;	\
	elif [ $(BRANCH) = 'develop' ];						\
	then												\
		docker tag $(NAME):$(VERSION) $(NAME):develop;	\
		docker tag $(NAME):$(VERSION) $(NAME):latest;	\
	fi

push: tag
	@if [ $(BRANCH) = 'master' ];						\
	then												\
		docker push $(NAME);							\
	else												\
		echo 'Please push from the master branch!';		\
	fi

list:
	docker images $(NAME)
