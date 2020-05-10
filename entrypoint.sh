#!/bin/sh

DATADIR=/atheme/etc
if ! test -w "$DATADIR/"; then
    echo "ERROR: $DATADIR must be mounted to a directory writable by UID $(cat /.atheme_uid)"
    exit 1
fi

DBPATH="$DATADIR/services.db"
if test -f "$DBPATH" && ! test -r "$DBPATH"; then
    echo "ERROR: $DBPATH must be readable by UID $(cat /.atheme_uid)"
    exit 1
fi

TMPPATH="$DATADIR/services.db.new"
if test -f "$TMPPATH" && ! test -w "$TMPPATH"; then
    echo "ERROR: $TMPPATH must either not exist or be writable by UID $(cat /.atheme_uid)"
    exit 1
fi

rm -f /atheme/var/atheme.pid
/atheme/bin/atheme-services -n "$@"
