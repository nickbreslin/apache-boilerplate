#!/bin/bash
# chmod u+x


function create_dir {

	DOMAIN=$1

	if [[ "$DOMAIN" = "" ]] ; then
		error "create_dir(): No DOMAIN"
	fi

	DIRS[0]="/srv/"
	DIRS[1]="/srv/www/"
	DIRS[2]="/srv/www/"
	DIRS[3]="/srv/www/$DOMAIN/"
	DIRS[4]="/srv/www/$DOMAIN/html/"
	DIRS[5]="/srv/www/$DOMAIN/logs/"


	for DIR in "${DIRS[@]}" ; do 
		if [[ ! -d $DIR ]] ; then
			mkdir $DIR
			output $DIR
		fi
	done
}


function create_files {

	DOMAIN=$1

	if [[ "$DOMAIN" = "" ]] ; then
		error "create_files(): No DOMAIN"
	fi

	# PHP Info
	if [ ! -f /srv/www/$DOMAIN/html/info.php ] ; then
		echo "<?php phpinfo(); ?>" >> /srv/www/$DOMAIN/html/info.php
		output "info file created"
	else
		warn "Info file for $DOMAIN already exists"
	fi

	# Placeholder Index
	if [ ! -f /srv/www/$DOMAIN/html/index.php ] ; then
		echo "Welcome to $DOMAIN" >> /srv/www/$DOMAIN/html/index.php
		output "index file created"
	else
		warn "Index file for $DOMAIN already exists"
	fi

	# Placeholder Index
	if [ ! -f /srv/www/$DOMAIN/html/loadbalancer.txt ] ; then
        echo "." >> /srv/www/$DOMAIN/html/loadbalancer.txt
        output "loadbalancer file created"
	else
		warn "Loadbalancer file for $DOMAIN already exists"
	fi
}