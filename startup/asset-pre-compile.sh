#! /bin/sh

# Precompile assets for production
rake assets:precompile

# copy assets referred by database
cp app/assets/images/* public/assets/

echo "assets pre-compiled..."
