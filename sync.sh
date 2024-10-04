#!/usr/bin/sh

source ~/venv/bin/activate

sudo cp -r ./site/* /srv/http/

rm -rf ./site/*

mkdocs gh-deploy
