#!/bin/bash
#
### BEGIN INIT INFO
# Provides:          sickbeard
# Required-Start:    $local_fs $network $remote_fs
# Required-Stop:     $local_fs $network $remote_fs
# Should-Start:      $NetworkManager
# Should-Stop:       $NetworkManager
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts instance of SickBeard
# Description:       starts instance of SickBeard using start-stop-daemon
### END INIT INFO

# Script name
NAME=sickbeard

# App name
DESC=SickBeard

## The defaults
# Run as username 
RUN_AS=CHANGEME

# Path to app SB_HOME=path_to_app_SickBeard.py
APP_PATH=/opt/sickbeard

# Data directory where sickbeard.db, cache and logs are stored
DATA_DIR=/opt/sickbeard/data

# Path to store PID file
PID_FILE=/var/run/sickbeard/sickbeard.pid

# path to python bin
DAEMON=/usr/bin/python

# Extra daemon option like: SB_OPTS=" --config=/home/sickbeard/config.ini"
EXTRA_DAEMON_OPTS=" --config=/opt/sickbeard/config.ini"

# Extra start-stop-daemon option like START_OPTS=" --group=users"
EXTRA_SSD_OPTS=
##

PID_PATH=`dirname $PID_FILE`
DAEMON_OPTS=" SickBeard.py -q --daemon --nolaunch --pidfile=${PID_FILE} --datadir=${DATA_DIR} ${EXTRA_DAEMON_OPTS}"

##

test -x $DAEMON || exit 0

set -e

# Create PID directory if not exist and ensure the SickBeard user can write to it
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
