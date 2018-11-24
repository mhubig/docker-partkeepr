#!/usr/bin/env make -f
#
# Copyright (C) 2014-2018, Markus Hubig <mhubig@gmail.com>
#

ORG     := mhubig
APP     := partkeepr
NAME    := $(ORG)/$(APP)
BRANCH  := $(shell git rev-parse --abbrev-ref HEAD)
VERSION := $(shell git describe)

.PHONY: all build tag push list

all: build

build:
	@if ! docker images $(NAME) | awk '{ print $$2 }' |	\
		grep -q -F $(VERSION);							\
	then												\
		docker build -t $(NAME):$(VERSION) --rm .;		\
	else												\
		true;											\
	fi													\

	# if we're on develop, do it anyway
	@if  [ $(BRANCH) = 'develop' ];						\
	then												\
		docker build -t $(NAME):$(VERSION) --rm .;		\
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
