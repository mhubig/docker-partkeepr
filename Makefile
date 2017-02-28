#!/usr/bin/make -f
#
# Copyright (C) 2014-2017, Markus Hubig <mh@imko.de>
#

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
	@if  [ $(BRANCH) = 'master' ];						\
	then												\
		docker tag $(NAME):$(VERSION) $(NAME):latest;	\
	elif [ $(BRANCH) = 'develop' ];						\
	then												\
		docker tag $(NAME):$(VERSION) $(NAME):develop;	\
		docker tag $(NAME):$(VERSION) $(NAME):latest;	\
	fi

push: tag
	@docker push $(NAME):$(VERSION);

	@if  [ $(BRANCH) = 'master' ];						\
	then												\
		docker push $(NAME):latest;						\
	elif [ $(BRANCH) = 'develop' ];						\
	then												\
		docker push $(NAME):develop;					\
	fi

list:
	docker images $(NAME)
