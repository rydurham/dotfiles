#!/bin/bash

# Install
sudo apt install postgresql postgresql-contrib -y

# Configure
sudo -u postgres
sudo -u postgres createuser ryan -s
sudo -u postgres createdb ryan
sudo -u postgres psql -c "ALTER USER ryan WITH PASSWORD 'secret'"
