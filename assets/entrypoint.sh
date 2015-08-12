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
# CONFIGURE
#

find ${DOCUMENT_ROOT} -type f -name "*.docker" | while read F
do
	SETTINGS_PATH=`echo "${F}" | sed "s/\.docker$//"`
	cp ${F} ${SETTINGS_PATH}
	/bin/sed -i "s@{{ DB_HOST }}@db@" ${SETTINGS_PATH}
	/bin/sed -i "s@{{ DB_PORT }}@${DB_PORT_3306_TCP_PORT}@" ${SETTINGS_PATH}
	/bin/sed -i "s@{{ DB_NAME }}@${DB_ENV_MYSQL_DATABASE}@" ${SETTINGS_PATH}
	/bin/sed -i "s@{{ DB_USER }}@${DB_ENV_MYSQL_USER}@" ${SETTINGS_PATH}
	/bin/sed -i "s@{{ DB_PASSWORD }}@${DB_ENV_MYSQL_PASSWORD}@" ${SETTINGS_PATH}
done



#############################
## COMMAND
#############################

echo $1

if [ "$1" = 'apache2-foreground' ]; then
	cron -f &
	exec /usr/local/bin/apache2-foreground
fi

exec "$@"
