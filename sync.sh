#!/usr/bin/sh

source ~/venv/bin/activate

rm -rf ./site/*

mkdocs build

cp -r ./site/* /srv/http/
