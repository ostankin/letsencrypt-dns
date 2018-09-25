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
  sed -i 's|="https://acme-v02.api.|="https://acme-staging-v02.api.|g' "$DEHYDRATED_EXECUTABLE"
fi

# if delegated domain provided, add it to the hook
if [[ "${CERTBOT_DELEGATED:-"False"}" != "False" ]]; then
 sed -i 's|lexicon \$PROVIDER|lexicon --delegated="${CERTBOT_DELEGATED}" $PROVIDER|g' "$DEHYDRATED_HOOK"
fi

CERTBOT_ALIAS_ARG=
if [[ -n "${CERTBOT_ALIAS:-}" ]]; then
  CERTBOT_ALIAS_ARG="--alias $CERTBOT_ALIAS"
fi

shopt -u nocasematch

echo "Config fragment:"
grep -A2 "# Default values" "$DEHYDRATED_EXECUTABLE"

while :;
do
  "$DEHYDRATED_EXECUTABLE" --cron --accept-terms --hook "$DEHYDRATED_HOOK" --challenge dns-01 --domain "$CERTBOT_DOMAIN" --out "$OUTPUT_LOCATION" $CERTBOT_ALIAS_ARG
  echo "Sleeping for $SLEEP_TIME until next check."
  sleep "$SLEEP_TIME"
done
