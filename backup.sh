#!/usr/bin/sh

source ~/venv/bin/activate
mkdocs gh-deploy
git add .
git commit -m "backup"
git push
