#!/usr/bin/env bash

set -e
set -u
set -o pipefail

DIR="`dirname \"$0\"`"
NODE_ENV=${NODE_ENV:=development}

cd $DIR/..

if test -f "../.env"; then
  set -a; source ../.env; set +a;
fi

if test -f ".env"; then
  set -a; source .env; set +a;
fi

if [ "$NODE_ENV" == "production" ]; then
  DATABASE_URL=$DATABASE_URL?ssl=true;
fi;

if [ "$NODE_ENV" == "test" ]; then
  DATABASE_URL="${DATABASE_URL}_test";
fi;

./node_modules/.bin/babel-node ./node_modules/.bin/db-migrate up --sql-file --env $NODE_ENV -m db/migrations

