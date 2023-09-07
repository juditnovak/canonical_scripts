#! /bin/bash

# Pack the new version of the charm

cd tests/integration/application-charm/ ; charmcraft pack; cd ../../..
cd tests/integration/database-charm/ ; charmcraft pack; cd ../../..


# Refresh it in the existing installation

juju refresh database --switch ./tests/integration/database-charm/database_ubuntu-22.04-amd64.charm
juju refresh application --switch ./tests/integration/application-charm/application_ubuntu-22.04-amd64.charm


# How do we look?

juju status
