#!/bin/sh

## NEED TO COMPLETE THE SCRIPT, THEN PLACE IN DOCKERFILE

BASE_DIR="./tmp" #/opt/wordpress

mkdir -p $BASE_DIR

WP_CLI="$BASE_DIR/wp-cli.phar"
WP_CLI_ASC="$BASE_DIR/wp-cli.phar.asc"
WP_KEYRING="$BASE_DIR/wp-cli.gpg"

# Download WP-CLI
curl --output $WP_CLI https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Download signature
curl --output $WP_CLI_ASC https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc

# Import signing key (first time only)
curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp | gpg --no-default-keyring --keyring $WP_KEYRING --import

gpgv --status-fd 2 --keyring $WP_KEYRING $WP_CLI_ASC $WP_CLI 
