#! /bin/bash

# Get the latest version of the libs

cp lib/charms/data_platform_libs/v0/data_interfaces.py tests/integration/application-charm/lib/charms/data_platform_libs/v0
cp lib/charms/data_platform_libs/v0/data_interfaces.py tests/integration/database-charm/lib/charms/data_platform_libs/v0/


# Remove existing apps (wait until done)

juju remove-application --force database
juju remove-application --force application 

while [[ `juju status | grep "application"` ]]
do
    sleep 3
done

while [[ `juju status | grep "database"` ]]
do
    sleep 3
done

sleep 5


# Pack the charms

cd tests/integration/application-charm/ ; charmcraft pack; cd ../../..
cd tests/integration/database-charm/ ; charmcraft pack; cd ../../..


# Deploy charms

juju deploy ./tests/integration/database-charm/database_ubuntu-22.04-amd64.charm --resource database-image=ubuntu/postgres@sha256:f0b7dcc3088c018ebcd90dd8b4e9007b094fd180d5a12f5be3e7120914ac159d
juju deploy ./tests/integration/application-charm/application_ubuntu-22.04-amd64.charm


# Relate charms

juju relate application:first-database database


# What do we look like?

juju status
