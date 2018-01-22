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

./node_modules/.bin/db-migrate create $1 --sql-file --env ${NODE_ENV} -m db/migrations

