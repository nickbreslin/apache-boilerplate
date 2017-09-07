#!/bin/bash
# chmod u+x

#
# Creates the apache config file at /etc/apache2/sites-available/
# Creates the symbolic link at /etc/sites-enabled/
# File name is based on domain.
#
# Includes argument for protocol (http/https)
# Includes redirect for http to https
# ELB healthcheck compatible
# Includes argument for apex redirect for www and non-www domains
# Includes option to define protocol
#
function create_apache {

	DOMAIN=$1
	PROTOCOL=$2
	APEX=$3
	DOCROOT=$4
	SUBDOMAIN=""

	if [[ "$DOMAIN" = "" ]] ; then
		error "create_apache(): No DOMAIN"
	fi

	CONFIG="/etc/apache2/sites-available/$DOMAIN.conf"

	if [[ -f $CONFIG ]] ; then
		warn "Apache config for $DOMAIN already exists"
		return 1;
	fi

	output "creating apache config: $DOMAIN"

	touch $CONFIG
	ln -s /etc/apache2/sites-available/$DOMAIN.conf /etc/apache2/sites-enabled/$DOMAIN.conf

	if [[ "$APEX" = "true" ]] ; then 
		if echo "$DOMAIN" | grep -q "www" ; then
			SUBDOMAIN=${DOMAIN#"www."}
		else
	  		error "DOMAIN requires www for APEX Redirect: $DOMAIN";
		fi
	fi



	#Create 
	echo "<VirtualHost *:80>"      >> $CONFIG
	echo "    ServerName $DOMAIN"  >> $CONFIG
	echo "    ServerAlias $DOMAIN" >> $CONFIG

	if [[ $SUBDOMAIN != "" ]] ; then
		output "Adding apex alias"
		echo "    ServerAlias $SUBDOMAIN" >> $CONFIG
	fi

	if [[ $PROTOCOL == "https" ]] || [[ $SUBDOMAIN != "" ]] ; then 
		echo ""                     >> $CONFIG
		echo "    RewriteEngine On" >> $CONFIG
	fi

	if [[ $SUBDOMAIN != "" ]] ; then
		output "Adding apex redirect"
		echo ""                                                           >> $CONFIG
		echo "    RewriteCond %{HTTP_HOST} !$DOMAIN$ [NC]"                >> $CONFIG
		echo "    RewriteRule (.*) $PROTOCOL://$DOMAIN\$1 [L,R=301]"      >> $CONFIG
	fi
		
	if [[ $PROTOCOL == "https" ]] ; then
		output "Adding https redirect"
		echo ""                                                              >> $CONFIG
		echo "    RewriteCond %{HTTP:X-Forwarded-Proto} !https"              >> $CONFIG
		echo "    RewriteCond $1 !^(loadbalancer.txt)"                       >> $CONFIG
		echo "    RewriteCond %{HTTP_USER_AGENT} !^ELB-HealthChecker"        >> $CONFIG
		echo "    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R,L]" >> $CONFIG
	fi

	echo ""                                                        >> $CONFIG
	echo "    DocumentRoot /srv/www/$DOMAIN/html/$DOCROOT"         >> $CONFIG
	echo "    DirectoryIndex index.php"                            >> $CONFIG
    echo "    <Directory \"/srv/www/$DOMAIN/html\">"               >> $CONFIG
    echo "        Options All"                                     >> $CONFIG
    echo "        AllowOverride All"                               >> $CONFIG
    echo "        Require all granted"                             >> $CONFIG
 	echo "    </Directory>"                                        >> $CONFIG
	echo "    ErrorLog /srv/www/$DOMAIN/logs/error.log"            >> $CONFIG
	echo "    CustomLog /srv/www/$DOMAIN/logs/access.log combined" >> $CONFIG
	echo "</VirtualHost>" >> $CONFIG
}