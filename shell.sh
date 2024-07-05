#!/bin/sh
#shellcheck disable=SC2009,SC2046

if [ -f "/.cryptdev" ]; then
    if eval /sbin/cryptsetup luksOpen "$(cat /.cryptdev)" "$(cat /.cryptname)" "$(cat /.cryptargs)"; then
        touch /.done
        killall cryptsetup > /dev/null 2>&1

        pid=$(ps | grep "[p]lymouth ask-for-password" | awk '{print $1}')
        if [ -n "$pid" ]; then
            kill "$pid"
        fi
    fi
else
    echo "Encryption bootup not yet complete - please wait!"
fi
