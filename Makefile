.PHONY: all host gh sync serve

# Variables
VENV_PATH = ~/venv/bin/activate
SITE_DIR = site
DEST_DIR = /srv/http/

all: gh sync

req:
	@echo "Installing dependencies..."
	@pip install -r requirements.txt

# host:
# 	@echo "Building site with MkDocs..."
# 	@source $(VENV_PATH) && mkdocs build
# 	@echo "Copying site files to destination..."
# 	@cp -r $(SITE_DIR)/* $(DEST_DIR)

gh:
	@echo "Deploying site to GitHub Pages..."
	@source $(VENV_PATH) && mkdocs gh-deploy

serve:
	@echo "Serving site locally..."
	@source $(VENV_PATH) && mkdocs serve

sync:
	@echo "Syncing with Git repository..."
	@git add . && git commit -m "backup" && git push

clean:
	rm -rf $(SITE_DIR)
