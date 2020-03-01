#!/bin/sh
# Write Docker tags for Drone CI: version-YYMMDD, version, maj.min, maj, latest

VERSION="$1"
SUFFIX="$2"

if test -z "$VERSION"; then
    echo "Usage: $0 <version> [<suffix>]"
    exit 1
fi

if test -n "$SUFFIX"; then
    case $SUFFIX in
    "-"*) SUFFIX_HYPHENATED="$SUFFIX" ;;
    *)    SUFFIX_HYPHENATED="-$SUFFIX" ;;
    esac
fi

# Date based tag
printf '%s' "$VERSION-$(date +%Y%m%d)$SUFFIX_HYPHENATED,"
# Program version
printf '%s' "$VERSION$SUFFIX_HYPHENATED,"
# Major program version
printf '%s' "$(printf '%s' "$VERSION" | cut -d . -f 1)"
printf '%s' "$SUFFIX_HYPHENATED,"
# maj.min pair. FIXME: failover if program version is not in the form x.y.z
printf '%s' "$(printf '%s' "$VERSION" | cut -d . -f 1-2)"
printf '%s' "$SUFFIX_HYPHENATED,"

if test -z "$SUFFIX"; then
    echo latest
else
    echo "$SUFFIX"
fi
