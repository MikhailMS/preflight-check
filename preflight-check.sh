#!/bin/bash

# COLOUR CONSTANTS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

source flight-flavour.sh

if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X
    macos_flavour
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux
    linux_flavour
fi
