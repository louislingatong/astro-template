#!/bin/bash
mkdir -p /etc/nginx/ssl

openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Convert the string to lowercase
APPS_LOWER=$(echo "$APPS" | tr '[:upper:]' '[:lower:]')
# Separate the apps in a comma
CHAR_SEPARATED_APPS=$(echo "$APPS_LOWER" | tr ' ' ',')
# Break the string by a comma
IFS=',' read -ra APPS_ARRAY <<< "$CHAR_SEPARATED_APPS"

# Iterate over all the values in the array
for APP in "${APPS_ARRAY[@]}"
do
  # Check if the string is not string
  if [ ! -z "$APP" ]
  then
    # Copy the unconfigured *.conf file as a configuration file for the app
    cp /etc/nginx/conf.d/configuration-file.conf.unconfigured /etc/nginx/conf.d/$APP.conf

    # Replace the API_DOMAIN string from the copied configuration file
    sed -i "s/API_DOMAIN/api.$APP.local/g" /etc/nginx/conf.d/$APP.conf

    # Replace the APP_DOMAIN string from the copied configuration file
    sed -i "s/APP_DOMAIN/$APP.local/g" /etc/nginx/conf.d/$APP.conf

    # Create self-signed SSL certificate for the APP domain
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
      -keyout /etc/nginx/ssl/$APP.local.key -out /etc/nginx/ssl/$APP.local.cert -extensions san -config \
      <(echo "[req]";
        echo distinguished_name=req;
        echo "[san]";
        echo subjectAltName=DNS:$APP.local,IP:10.0.0.1
      ) \
      -subj /CN=$APP.local

    # Create self-signed SSL certificate for the API domain
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
      -keyout /etc/nginx/ssl/api.$APP.local.key -out /etc/nginx/ssl/api.$APP.local.cert -extensions san -config \
      <(echo "[req]";
        echo distinguished_name=req;
        echo "[san]";
        echo subjectAltName=DNS:api.$APP.local,IP:10.0.0.1
        ) \
      -subj /CN=api.$APP.local
  fi
done

# Delete the unconfigured conf file
rm /etc/nginx/conf.d/configuration-file.conf.unconfigured
