#!/bin/bash

git commit --allow-empty -m "[skip ci] finished build: $BUDDYBUILD_BUILD_NUMBER"
git tag "bb-$BUDDYBUILD_BUILD_NUMBER"
git push --tags
