#!/usr/bin/sh

sudo cp -r ./site/* /srv/http/

rm -rf ./site/*

mkdocs gh-deploy
