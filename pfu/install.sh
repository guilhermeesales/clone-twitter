#!/bin/sh

mix deps.get
cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

#npm install --save-dev @fortawesome/fontawesome-free
#npm install file-loader
#npm install bootstrap
cd ../

#mix setup

#iex -S mix phx.server

