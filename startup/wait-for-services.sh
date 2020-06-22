#! /bin/sh

# Wait for Database
until nc -z -v -w30 $DATABASE_HOST 3306; do
 echo -n 'Waiting for Database... '
 sleep 1
done
echo "Database is up and running..."
