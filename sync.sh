#!/usr/bin/sh

rm -rf ./site/*
rm -rf ./.cache/*

mkdocs build
mkdocs gh-deploy
