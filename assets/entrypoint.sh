#!/bin/bash

DOCUMENT_ROOT=/var/www/html/


#
# Configure SSMTP
#

SSMTP_SETTINGS_PATH=/etc/ssmtp/ssmtp.conf
cp /opt/docker/ssmtp.conf ${SSMTP_SETTINGS_PATH}
/bin/sed -i "s#{{ SSMTP_ROOT }}#${SSMTP_ROOT}#" ${SSMTP_SETTINGS_PATH}
/bin/sed -i "s@{{ SSMTP_MAILHUB }}@${SSMTP_MAILHUB}@" ${SSMTP_SETTINGS_PATH}
/bin/sed -i "s@{{ SSMTP_HOSTNAME }}@${SSMTP_HOSTNAME}@" ${SSMTP_SETTINGS_PATH}


#
# Copy default configuration files
#

cp -r /var/www/html/config.original/* /var/www/html/config/

#############################
## COMMAND
#############################

echo $1

if [ "$1" = 'apache2-foreground' ]; then
	cron -f &
	exec /usr/local/bin/apache2-foreground
fi

exec "$@"
