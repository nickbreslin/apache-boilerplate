#!/bin/bash
# chmod u+x

#
# Environment boilerplate
# PHP 7.0.22
# Ubuntu 16.04.1
# Apache 2.4.18

#
# directs:
#    - http://domain
#    - https://domain
#    - http://www.domain
#
# ...to https://www.domain
#
# Example
# sudo bash create.sh www.booshlin.com https true
#
# sudo bash create nosubdomain.com
# sudo bash create securedomain.com https
#

#
# Include additional libraries
#
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/lib/util.sh"
source "$DIR/lib/dir.sh"
source "$DIR/lib/apache.sh"

output
info "Running apache boilerplate"
output

#
# Script arguments
#
PARAMS=( "$@" )
# TODO - Remove | Debug
output ${PARAMS[*]}

DOMAIN=${PARAMS[0]}   # domain without protocol
PROTOCOL=${PARAMS[1]}  # http | https
APEX=${PARAMS[2]}  # true|false should redirect apex (non-www) to this subdomain (www)
DOCROOT=${PARAMS[3]}   # define doc root other than /html/


if [[ "$DOMAIN" = "" ]] ; then
	error "No DOMAIN"
fi

if [[ "$PROTOCOL" = "" ]] ; then
	PROTOCOL="http"
fi

if [[ "$PROTOCOL" != "http" ]] && [[ "$PROTOCOL" != "https" ]] ; then
		error "PROTOCOL must be http or https"
fi

if [[ "$APEX" = "" ]] ; then
	APEX="false"
fi

if [[ "$APEX" != "true" ]] && [[ "$APEX" != "false" ]] ; then
	error "APEX must be true or false"
fi

if [[ "$DOCROOT" = "" ]] ; then
	DOCROOT=""
fi


#
# Directories
#
info "Creating directories..."

create_dir $DOMAIN

success "DONE"
output

#
# Base files
#
info "Creating web files..."

create_files $DOMAIN

success "DONE"
output

#
# Apache
#
info "Creating apache files..."

create_apache $DOMAIN $PROTOCOL $APEX $DOCROOT 

success "DONE"
output


output

# Change ownership to www-data
output "Modifying permissions..."
chown -R www-data /srv/www/$DOMAIN

# Restart Apache
output "Restarting Apache..."
service apache2 restart


output
success "SCRIPT COMPLETE"

output