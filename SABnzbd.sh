#!/bin/bash
#
################################################
#                                              #
#  TO CONFIGURE EDIT /opt/sabnzbd/sabnzbd.ini  #
#                                              #
################################################
#
### BEGIN INIT INFO
# Provides:          sabnzbd
# Required-Start:    $local_fs $network $remote_fs
# Required-Stop:     $local_fs $network $remote_fs
# Should-Start:      NetworkManager
# Should-Stop:       NetworkManager
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: SABnzbd+ binary newsgrabber
# Description:       SABnzbd+ is a web-based binary newsgrabber with nzb
#                    support, designed to download files from Usenet.
#                    This script provides that functionality as a system
#                    service, starting the program on boot.
### END INIT INFO

DAEMON=/opt/sabnzbd
SETTINGS=/opt/sabnzbd/sabnzbd.ini

([ -x $DAEMON ] && [ -r $SETTINGS ]) || exit 0

DESC="SABnzbd+ binary newsgrabber"
DEFOPTS="--daemon"
PYTHONEXEC="^$(sed -n '1s/^#\!\([a-z0-9\.\/]\+\)\(.*\)/\1(\2)?/p' $DAEMON)"
PIDFILE=/var/run/sabnzbd/sabnzbd.pid
SETTINGS_LOADED=FALSE

# these are only accepted from the settings file
unset USER CONFIG HOST PORT EXTRAOPTS

. /lib/lsb/init-functions

check_retval() {
        if [ $? -eq 0 ]; then
                log_end_msg 0
                return 0
        else
                log_end_msg 1
                exit 1
        fi
}

is_running() {
        # returns 0 when running, 1 otherwise
        PID="$(pgrep -f -x -u ${USER%:*} "$PYTHONEXEC $DAEMON $DEFOPTS.*")"
        RET=$?
        [ $RET -gt 1 ] && exit 1 || return $RET
}

load_settings() {
        # returns 0 when running, 1 otherwise
        PID="$(pgrep -f -x -u ${USER%:*} "$PYTHONEXEC $DAEMON $DEFOPTS.*")"
        RET=$?
        [ $RET -gt 1 ] && exit 1 || return $RET
}

load_settings() {
        if [ $SETTINGS_LOADED != "TRUE" ]; then
                . $SETTINGS

                [ -z "$USER" ] && {
                        log_warning_msg "$DESC: not configured, aborting. See $SETTINGS";
                        return 1; }
                [ -z "${USER%:*}" ] && exit 1

                OPTIONS="$DEFOPTS"
                [ -n "$CONFIG" ] && OPTIONS="$OPTIONS --config-file $CONFIG"
                [ -n "$HOST" ] && SERVER="$HOST" || SERVER=
                [ -n "$PORT" ] && SERVER="$SERVER:$PORT"
                [ -n "$SERVER" ] && OPTIONS="$OPTIONS --server $SERVER"
                [ -n "$EXTRAOPTS" ] && OPTIONS="$OPTIONS $EXTRAOPTS"
                SETTINGS_LOADED=TRUE
        fi
        return 0
}

start_sab() {
        load_settings || exit 0
        if ! is_running; then
                log_daemon_msg "Starting $DESC"
                start-stop-daemon --quiet --chuid $USER --start --exec $DAEMON -- $OPTIONS
                check_retval
                # create a pidfile; we don't use it but some monitoring app likes to have one
                [ -w $(dirname $PIDFILE) ] && \
                        pgrep -f -x -n -u ${USER%:*} "$PYTHONEXEC $DAEMON $OPTIONS" > $PIDFILE
        else
                log_success_msg "$DESC: already running (pid $PID)"
        fi
}

stop_sab() {
        load_settings || exit 0
        if is_running; then
                TMPFILE="$(mktemp --tmpdir sabnzbdplus.XXXXXXXXXX)"
                [ $? -eq 0 ] || exit 1
                trap '[ -f "$TMPFILE" ] && rm -f "$TMPFILE"' EXIT
                echo "$PID" > "$TMPFILE"
                log_daemon_msg "Stopping $DESC"
                start-stop-daemon --stop --user ${USER%:*} --pidfile "$TMPFILE" --retry 30
                check_retval
        else
                log_success_msg "$DESC: not running"
        fi
        [ -f $PIDFILE ] && rm -f $PIDFILE
}

case "$1" in
        start)
                start_sab
        ;;
        stop)
                stop_sab
        ;;
        force-reload|restart)
                stop_sab
                start_sab
        ;;
        status)
                load_settings || exit 4
                if is_running; then
                        log_success_msg "$DESC: running (pid $PID)"
                else
                        log_success_msg "$DESC: not running"
                        [ -f $PIDFILE ] && exit 1 || exit 3
                fi
        ;;
        *)
                log_failure_msg "Usage: $0 {start|stop|restart|force-reload|status}"
                exit 3
        ;;
esac

exit 0				