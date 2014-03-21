#!/bin/bash
#
# Copyright (C) 2014, Markus Hubig <mhubig@imko.de>
#

VERSION_FILE='README.md'
VERSION_TEMP='.README.md.new'

function usage () {
    echo "usage: bump-version <version-id>"
}

function commit_hint () {
    MSG1="Now please commit with something like:"
    MSG2="git commit -a -s -m \"Bumped version number to $1.\""
    echo $MSG1 $MSG2
}

function update_version () {
    sed -e "s/mhubig\/partkeepr:.*$/mhubig\/partkeepr:$1/g" \
        $VERSION_FILE > $VERSION_TEMP
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

if ! update_version $1; then
    echo "Could not bump the version!" >&2
    exit 2
else
    mv $VERSION_TEMP $VERSION_FILE
fi

commit_hint $1
