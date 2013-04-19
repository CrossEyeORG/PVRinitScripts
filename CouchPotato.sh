#!/bin/bash
#
### BEGIN INIT INFO
# Provides:          couchpotato
# Required-Start:    $local_fs $network $remote_fs
# Required-Stop:     $local_fs $network $remote_fs
# Should-Start:      $NetworkManager
# Should-Stop:       $NetworkManager
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts instance of CouchPotato
# Description:       starts instance of CouchPotato using start-stop-daemon
### END INIT INFO

# Script name
NAME=couchpotato

# App name
DESC=CouchPotato

## The defaults
# Run as username 
RUN_AS=CHANGEME

# Path to app SB_HOME=path_to_app_couchpotato.py
APP_PATH=/opt/couchpotato

# Data directory where couchpotato.db, cache and logs are stored
DATA_DIR=/opt/couchpotato/data

# Path to store PID file
PID_FILE=/var/run/couchpotato/couchpotato.pid

# path to python bin
DAEMON=/usr/bin/python

# Extra daemon option like: CP_OPTS=" --config=/home/couchpotato/config.ini"
EXTRA_DAEMON_OPTS=" --config=/opt/couchpotato/config.ini"

# Extra start-stop-daemon option like START_OPTS=" --group=users"
EXTRA_SSD_OPTS=
##

PID_PATH=`dirname $PID_FILE`
DAEMON_OPTS=" CouchPotato.py --daemon --pid_file=${PID_FILE} --data_dir=${DATA_DIR} ${EXTRA_DAEMON_OPTS}"

##

test -x $DAEMON || exit 0

set -e

# Create PID directory if not exist and ensure the couchpotato user can write to it
if [ ! -d $PID_PATH ]; then
    mkdir -p $PID_PATH
    chown $RUN_AS $PID_PATH
fi

if [ ! -d $DATA_DIR ]; then
    mkdir -p $DATA_DIR
    chown $RUN_AS $DATA_DIR
fi

if [ -e $PID_FILE ]; then
    PID=`cat $PID_FILE`
    if ! kill -0 $PID > /dev/null 2>&1; then
        echo "Removing stale $PID_FILE"
        rm $PID_FILE
    fi
fi

case "$1" in
    start)
        echo "Starting $DESC"
        start-stop-daemon -d $APP_PATH -c $RUN_AS $EXTRA_SSD_OPTS --start --pidfile $PID_FILE --exec $DAEMON -- $DAEMON_OPTS
        ;;
    stop)
        echo "Stopping $DESC"
        start-stop-daemon --stop --pidfile $PID_FILE --retry 15
        ;;

    restart|force-reload)
        echo "Restarting $DESC"
        start-stop-daemon --stop --pidfile $PID_FILE --retry 15
        start-stop-daemon -d $APP_PATH -c $RUN_AS $EXTRA_SSD_OPTS --start --pidfile $PID_FILE --exec $DAEMON -- $DAEMON_OPTS
        ;;
    *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0
