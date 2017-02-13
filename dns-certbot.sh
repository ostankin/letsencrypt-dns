#!/usr/bin/env bash
set -eu
SLEEP_TIME="${CERTBOT_INTERVAL:-1d}"
OUTPUT_LOCATION="${CERTBOT_OUTPUT:-/certs}"
TEST_MODE="${CERTBOT_STAGING:-""}"

DEHYDRATED_DIR=/dehydrated
DEHYDRATED_EXECUTABLE="$DEHYDRATED_DIR/dehydrated"

if [ ! -z $TEST_MODE ]; then
  sed -i 's|="https://acme-v01.api.|="https://acme-staging.api.|g' "$DEHYDRATED_EXECUTABLE"
fi

echo "Config fragment"
grep -A2 "# Default values" "$DEHYDRATED_EXECUTABLE"

if [ ! -z ${DELEGATION_MASTER_DOMAIN:-""} ]; then
  DEHYDRATED_HOOK="dehydrated.delegated.sh"
else
  DEHYDRATED_HOOK="dehydrated.default.sh"
fi

echo "Dehydrated hook: $DEHYDRATED_HOOK"

while :;
do
  "$DEHYDRATED_EXECUTABLE" --cron --accept-terms --hook "$DEHYDRATED_DIR/$DEHYDRATED_HOOK" --challenge dns-01 --domain "$CERTBOT_DOMAIN" --out "$OUTPUT_LOCATION"
  echo "Sleeping for $SLEEP_TIME until next check."
  sleep "$SLEEP_TIME"
done
