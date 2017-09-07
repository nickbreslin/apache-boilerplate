# apache-boilerplate

Create Apache web environments 

## Install

1. Clone repository
1. `chmod u+x create.sh` to make it executable.

This is tested and executed in;
* Apache 2.4.18
* PHP 7.0.22
* Ubuntu 16.04.1

## Usage

`sudo bash create.sh [DOMAIN] [PROTOCOL] [APEX] [DOCROOT]`

### Arguments

*DOMAIN* is your web domain.

*PROTOCOL* can be http | https. if you set https, it will redirect all https to http.
- default is http

*APEX* is a redirect option. If set, it will redirect all non-www traffic
- default is false

*DOCROOT* from the install location for the web folder, define where yoru document root or public folder is
- default is /srv/www/DOMAIN/html/
- DOCROOT of public/ would make the apache document root /srv/www/DOMAIN/html/public/

### Examples

`sudo bash create.sh www.example.com` will create an http-only environment.

`sudo bash create.sh www.booshlin.com https true` will create an environment which all www and non-www traffic, http and https traffic is directed to https://www.booshlin.com



### Useful Links
* [Including other scripts](https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts)
* [Colors](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)