#!/bin/bash
# chmod u+x

#
# Color logging for cli execution
#
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

function error {
	echo -e "${RED}$1${NC}"
	echo "";
	exit
}

function warn {
	echo -e "${YELLOW}$1${NC}"
}

function success {
	echo -e "${GREEN}$1${NC}"
}

function info {
	echo -e "${CYAN}$1${NC}"
}

function output {
	echo -e "${NC}$1${NC}"
}