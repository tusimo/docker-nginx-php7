#!/bin/bash

set -eo pipefail

if [ -d "./scripts" ]
then
    for script in ./scripts/*; do
    	chmod 755 "$script";
        echo "running $script"; "$script";
    done
fi

export APP_ENV=${APP_ENV:-production}

exec "$@"