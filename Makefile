.PHONY: all req deploy serve clean

# Variables
SITE_DIR = site

all: gh sync

req:
	@echo "Installing dependencies..."
	@pip install -r requirements.txt

deploy:
	@echo "Deploying site to GitHub Pages..."
	@mkdocs gh-deploy

serve:
	@echo "Serving site locally..."
	@mkdocs serve

clean:
	rm -rf $(SITE_DIR)
