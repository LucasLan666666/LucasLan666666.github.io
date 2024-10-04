#!/usr/bin/sh

source ~/venv/bin/activate

rm -rf ./site/*

mkdocs gh-deploy

sudo cp -r ./site/* /srv/http/
