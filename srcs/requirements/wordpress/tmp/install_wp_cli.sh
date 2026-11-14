#!/bin/sh

## NEED TO COMPLETE THE SCRIPT, THEN PLACE IN DOCKERFILE

CWD="." #/opt/wordpress

mkdir -p $CWD

WP_CLI="$CWD/wp-cli.phar"
WP_CLI_ASC="$CWD/wp-cli.phar.asc"
WP_KEYRING="$CWD/wp-cli.gpg"

# Download WP-CLI
curl --output $WP_CLI https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Download signature
curl --output $WP_CLI_ASC https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc

# Import signing key (first time only)
curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp | gpg --no-default-keyring --keyring $WP_KEYRING --import

gpgv --status-fd 2 --keyring $WP_KEYRING $WP_CLI_ASC $WP_CLI 
