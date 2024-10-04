#!/usr/bin/sh

source ~/venv/bin/activate
mkdocs build
cp -r ./site/* /srv/http/
