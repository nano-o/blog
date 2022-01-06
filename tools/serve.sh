#!/usr/bin/env bash

#
# Author: Jake Zimmerman <jake@zimmerman.io>
#
# A simple script to launch a web server in this folder and start watchman.
#

# LICENSE: https://blueoakcouncil.org/license/1.0.0

set -euo pipefail

cd www/
python3 -m http.server "${PORT:-8000}" &
http_server_pid="$!"
cd -

xdg-open "http://127.0.0.1:8000"

watchman-make -p 'src/*' 'public/*' '*.html5' 'Makefile' -r 'make'
kill "$http_server_pid"
