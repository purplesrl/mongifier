#!/bin/bash

if ! [[ -v MYSQL_DB && -v MYSQL_USER && -v MYSQL_PASS && -v PROJECT && -v SQL_FILE && -v MYSQL_HOST ]] ; then
    exit 1
fi

TIMEOUT=10
until timeout $TIMEOUT bash -c 'cat < /dev/null > /dev/tcp/$MYSQL_HOST/3306' 2> /dev/null
do
	echo "[?] Waiting $TIMEOUT seconds for MYSQL connection to come up"
	sleep $TIMEOUT
done

sleep $TIMEOUT

DIR=/tmp
FILE=$(basename $SQL_FILE)
CONTAINER=${PROJECT}_mysql_1

echo "[+] Copying $FILE ..."
docker cp $SQL_FILE $CONTAINER:$DIR/$FILE
echo "[+] Importing $FILE ..."
MYSQL_HOST=`docker exec -ti $CONTAINER ip -4 addr show eth0 | sed -nr 's|.*inet ([^ ]+)/.*|\1|p'`
docker exec --env MYSQL_USER=$MYSQL_USER --env MYSQL_PASS=$MYSQL_PASS --env MYSQL_DB=$MYSQL_DB \
	--env DIR=$DIR --env FILE=$FILE --env MYSQL_HOST=$MYSQL_HOST \
	-ti $CONTAINER sh -c "mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB < $DIR/$FILE"
