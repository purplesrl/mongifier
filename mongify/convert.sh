#!/bin/sh

# Generate database config file from environment variables

CONFIG_TEMPLATE=/mongify/config/database.config.template
CONFIG=/mongify/data/database.config
TRANSLATION=/mongify/data/translation.rb
TIMEOUT=10

echo "[+] Generating config file"

perl -p -i -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < $CONFIG_TEMPLATE > $CONFIG

echo "[+] Checking connection"

until mongify check $CONFIG 2> /dev/null
do
	echo "[?] Connection check failed, waiting $TIMEOUT seconds..."
	sleep $TIMEOUT
done

echo "[+] Generating translation"

mongify translation $CONFIG > $TRANSLATION

sed -i '1s/^/# You make any changes and save this file before processing starts.\n/' $TRANSLATION

nano $TRANSLATION

echo "[+] Processing"

mongify process $CONFIG $TRANSLATION

