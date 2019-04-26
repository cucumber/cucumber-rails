#!/bin/bash

set -xeuo pipefail

curl --silent \
     --show-error \
     --location \
     --fail \
     --retry 3 \
     --output /tmp/geckodriver_linux64.tar.gz \
     https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz

sudo tar -C /usr/local/bin -xvzf /tmp/geckodriver_linux64.tar.gz geckodriver

rm /tmp/geckodriver_linux64.tar.gz

geckodriver --version

set +x
