#!/bin/sh
VERSION=`cat manifest.json | jq '.serial'`
git tag -as $VERSION -m "v$VERSION"