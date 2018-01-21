#!/bin/bash

# COLOUR CONSTANTS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

source flight-flavour.sh

if [ "$(uname -s)" == "Darwin" ]; then
    # Mac OS X
    macos_flavour
elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
    # RedHat/Centos
    redhat_flavour
elif [ "$(uname -s)" == "Linux" ]; then
    # GNU/Linux
    linux_flavour
fi
