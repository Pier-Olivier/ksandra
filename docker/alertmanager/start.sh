#!/bin/sh
set -e

in=/etc/alertmanager/alertmanager.yml
out=/etc/alertmanager/alertmanager.expanded.yml

# Expand environment variables into the config
sed \
  -e "s|\${SMTP_SMARTHOST}|${SMTP_SMARTHOST}|g" \
  -e "s|\${SMTP_FROM}|${SMTP_FROM}|g" \
  -e "s|\${SMTP_USERNAME}|${SMTP_USERNAME}|g" \
  -e "s|\${SMTP_PASSWORD}|${SMTP_PASSWORD}|g" \
  -e "s|\${ALERT_TO}|${ALERT_TO}|g" \
  "$in" > "$out"

exec /bin/alertmanager \
  --config.file="$out" \
  --cluster.listen-address=
