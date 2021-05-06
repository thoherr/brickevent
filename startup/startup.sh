#! /bin/sh

# Wait for DB services
 ./startup/wait-for-services.sh

# Prepare DB (Migrate - If not? Create db & Migrate)
./startup/prepare-db.sh

# Pre-comple app assets
./startup/asset-pre-compile.sh

# Start Application
bundle exec rails server -b 0.0.0.0
