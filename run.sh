#!/usr/bin/env sh

# Make sure we are in the root-directory
cd "$(dirname $0)"

# Load dependencies
. ./src/namedotcomddns.sh

run () {
  if [ -z "$USERNAME" ]; then >&2 echo "USERNAME is not set"; return 1; fi
  if [ -z "$TOKEN" ]; then >&2 echo "TOKEN is not set"; return 1; fi
  if [ -z "$DOMAINNAME" ]; then >&2 echo "DOMAINNAME is not set"; return 1; fi
  if [ -z "$HOST" ]; then >&2 echo "HOST is not set"; return 1; fi
  if [ -z "$TYPE" ]; then
    local TYPE="A"
  fi

  if ! updateRecordByHostWithExternalIp "$USERNAME" "$TOKEN" "$DOMAINNAME" "$HOST" "$TYPE" ; then
    >&2 echo "failed to update record"
    return 1
  fi

  return 0
}

run
exit $?
