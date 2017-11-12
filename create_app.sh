#!/bin/bash

set -euo pipefail

# Make sure the application name is passed in as a parameted
if [[ "$#" -lt 1 ]]; then
  echo "usage: $0 app_name" 1>&2
  exit 1
fi

APP_NAME=$1
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_PATH="$ROOT/$APP_NAME"
CONTROLLERS_PATH="$APP_PATH/controllers"
TEMPLATES_PATH="$APP_PATH/templates"

# If APP_PATH already exists, exit out
if [[ -d "$APP_PATH" ]]; then
  echo "Error: $APP_NAME already exists and shouldn't be overriden" 1>&2
  exit 1
fi
# If run.py already exists, exit out
if [[ -f "$ROOT/run.py"  ]]; then
  echo "Error: run.py already exists in $ROOT/run.py" 1>&2
  exit 1
fi

printf "\n> Create app directory\n"
mkdir -p "$CONTROLLERS_PATH/site"
mkdir -p $TEMPLATES_PATH

printf "\n> Create template files for a hello world app\n"
# $APP_PATH/__init__.py
cat <<END > "$APP_PATH/__init__.py"
from flask import Flask
import sys
app = Flask(__name__)

sys.path.append('$APP_NAME')
from $APP_NAME import controllers
END
# $CONTROLLERS_PATH/__init__.py
echo -e "from controllers.site import *\n" > "$CONTROLLERS_PATH/__init__.py"
# $CONTROLLERS_PATH/site/__init__.py
cat <<END > "$CONTROLLERS_PATH/site/__init__.py"
import os
from glob import glob

globbing = os.path.dirname(__file__) + '/*.py'
__all__ = [os.path.basename(f)[:-3] for f in glob(globbing)]
END
cat <<END > "$CONTROLLERS_PATH/site/hello.py"
from $APP_NAME import app

@app.route('/')
def index():
  return 'Hello World (From create_app.sh)'
END
cat <<END > "$ROOT/run.py"
from $APP_NAME import app
import os

DEBUG = os.getenv('DEBUG') == 'True'

if __name__ == '__main__':
  app.run(host='0.0.0.0', debug=DEBUG) 
END

printf "\n> Setup virtualenv\n"
docker-compose run app whoami > /dev/null
$ROOT/reset_virtualenv.sh

