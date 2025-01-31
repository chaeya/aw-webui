#!/bin/bash

mkdir -p $HOME/.config/activitywatch/aw-server

# Configure CORS
# FIXME: Why is this not needed for aw-server?
# FIXME: Ideally this should only need to contain the cors_origins keys, with fallback to defaults
echo "
[server]
host = localhost
port = 5600
storage = peewee
cors_origins = http://localhost:27180

[server-testing]
host = localhost
port = 5666
storage = peewee
cors_origins = http://localhost:27180
" >  $HOME/.config/activitywatch/aw-server/aw-server.ini
