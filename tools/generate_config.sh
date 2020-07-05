#!/bin/bash

if [ $# -ne 1 ]
then
    echo "usage: $0 docker-dir"
    exit 255
fi

DOCKERDIR=$1
cd $DOCKERDIR

if [ $? -ne 0 ]
then
    echo "ERROR: cannot change directory to $DOCKERDIR"
    exit 255
fi

DB_PASSWORD=$(pwgen 16 1)
DB_ROOT_PASSWORD=$(pwgen 16 1)
SECRET_KEY=$(pwgen 64 1)
SECRET_TOKEN=$(pwgen 64 1)

echo Generating files from templates with generated passwords and secret keys
sed -e "s/DB_PASSWORD_PLACEHOLDER/$DB_PASSWORD/g" -e "s/DB_ROOT_PASSWORD_PLACEHOLDER/$DB_ROOT_PASSWORD/g" \
    < docker-compose.yml.template \
    > docker-compose.yml
sed -e "s/DB_PASSWORD_PLACEHOLDER/$DB_PASSWORD/g" -e "s/DB_ROOT_PASSWORD_PLACEHOLDER/$DB_ROOT_PASSWORD/g" \
    < mysql/my.cnf.template \
    > mysql/my.cnf
sed -e "s/SECRET_KEY_PLACEHOLDER/$SECRET_KEY/g" \
    < config/devise.rb.template \
    > config/devise.rb
sed -e "s/SECRET_TOKEN_PLACEHOLDER/$SECRET_TOKEN/g" \
    < config/secret_token.rb.template \
    > config/secret_token.rb
cp config/production.rb.template config/production.rb

