#!/usr/bin/env bash
#
# Copyright (C) 2014-2017, Markus Hubig <mh@imko.de>
#

README_FILE='README.md'
README_TEMP='.README.md.new'

DOCKER_FILE='Dockerfile'
DOCKER_TEMP='.Dockerfile.new'

function usage () {
    echo "usage: bump-version <version-id>"
}

function commit_hint () {
    MSG1="Now please commit with something like:"
    MSG2="git commit -a -s -m \"Bumped version number to $1.\""
    echo $MSG1 $MSG2
}

function update_version () {
    sed -e "s/> The most resent version is:.*$/> The most resent version is: $1/g" \
        $README_FILE > $README_TEMP
    sed -e "s/ENV VERSION .*$/ENV VERSION $1/g" $DOCKER_FILE > $DOCKER_TEMP
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

if ! update_version $1; then
    echo "Could not bump the version!" >&2
    exit 2
else
    mv $README_TEMP $README_FILE
    mv $DOCKER_TEMP $DOCKER_FILE
fi

commit_hint $1
