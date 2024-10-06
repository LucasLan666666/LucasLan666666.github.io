.PHONY: all env host gh sync

# Variables
VENV_PATH = ~/venv/bin/activate
SITE_DIR = site
DEST_DIR = /srv/http/

all: host gh sync

req:
	@echo "Installing dependencies..."
	@pip install -r requirements.txt

env:
	@echo "Activating virtual environment..."
	@source $(VENV_PATH)

host: env
	@echo "Building site with MkDocs..."
	@source $(VENV_PATH) && mkdocs build
	@echo "Copying site files to destination..."
	@cp -r $(SITE_DIR)/* $(DEST_DIR)

gh: env
	@echo "Deploying site to GitHub Pages..."
	@source $(VENV_PATH) && mkdocs gh-deploy

sync:
	@echo "Syncing with Git repository..."
	@git add . && git commit -m "backup" && git push

clean:
	rm -rf $(SITE_DIR)
