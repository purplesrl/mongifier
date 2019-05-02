#!/bin/bash

CONTAINER=${PROJECT}_mysql_1
echo $CONTAINER
DB=$MYSQL_DB
USER=$MYSQL_USER
PASS=$MYSQL_PASS

HOST=`docker exec -ti $CONTAINER ip -4 addr show eth0 | sed -nr 's|.*inet ([^ ]+)/.*|\1|p'`
docker exec --env USER=$USER --env PASS=$PASS --env DB=$DB --env HOST=$HOST \
	-ti $CONTAINER sh -c "mysql -h $HOST -u$USER -p$PASS $DB"
