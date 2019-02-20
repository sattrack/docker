#!/bin/bash
set -x

# create directories
mkdir /data

# set proper permissions. make sure the user matches your `DOCKER_USER` setting in `.env`
chown 1000:1000 /data

# install pelias script
ln -s "$(pwd)/pelias" /usr/local/bin/pelias

# cwd
cd projects/brazil

# configure environment
sed -i '/DATA_DIR/d' .env
echo 'DATA_DIR=/data' >> .env

# run build
pelias compose pull
pelias elastic start
pelias elastic wait
pelias elastic create
pelias download all
pelias prepare all
pelias import all
pelias compose up

# optionally run tests
#pelias test run