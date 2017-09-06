#
# Environment boilerplate
# PHP 7.0.22
# Ubuntu 16.04.1
# Apache 2.4.18


#!/bin/bash
# chmod u+x

#
# ./create.sh booshlin.com https
# ./create.sh woolclad.com https

DOMAIN    = "$1" # omain without protocol
PROTOCOL  = "$2" # http | https | both
REDIRECT  = "$3" # redirect all traffic to https?
DOCROOT   = "$4" # define doc root other than /html/