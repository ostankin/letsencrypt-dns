#!/usr/bin/env bash
set -eu
SLEEP_TIME="${CERTBOT_INTERVAL:-1d}"
OUTPUT_LOCATION="${CERTBOT_OUTPUT:-/certs}"

DEHYDRATED_DIR=/dehydrated
DEHYDRATED_EXECUTABLE="$DEHYDRATED_DIR/dehydrated"
DEHYDRATED_HOOK="$DEHYDRATED_DIR/dehydrated.default.sh"

# in Staging mode replace ACME endpoint
shopt -s nocasematch
if [[ "${CERTBOT_STAGING:-"False"}" != "False" ]]; then
  sed -i 's|="https://acme-v01.api.|="https://acme-staging.api.|g' "$DEHYDRATED_EXECUTABLE"
fi

# if delegated domain provided, add it to the hook
if [[ "${CERTBOT_DELEGATED:-"False"}" != "False" ]]; then
 sed -i 's|lexicon \$PROVIDER|lexicon --delegated="${CERTBOT_DELEGATED}" $PROVIDER|g' "$DEHYDRATED_HOOK"
fi
shopt -u nocasematch

echo "Config fragment:"
grep -A2 "# Default values" "$DEHYDRATED_EXECUTABLE"

while :;
do
  "$DEHYDRATED_EXECUTABLE" --cron --accept-terms --hook "$DEHYDRATED_HOOK" --challenge dns-01 --domain "$CERTBOT_DOMAIN" --out "$OUTPUT_LOCATION"
  echo "Sleeping for $SLEEP_TIME until next check."
  sleep "$SLEEP_TIME"
done
