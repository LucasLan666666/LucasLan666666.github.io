#!/usr/bin/sh

rm -rf ./site/*

mkdocs build
mkdocs gh-deploy
