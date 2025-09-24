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

# Generate auth.yml for basic authentication
if [ -z "$PROM_PWD_HASH" ]; then
  echo "PROM_PWD_HASH is not set!" >&2
  exit 1
fi

cat <<EOF > /etc/alertmanager/auth.yml
basic_auth_users:
  admin: "$PROM_PWD_HASH"
EOF

exec /bin/alertmanager \
  --config.file="$out" \
  --web.config.file=/etc/alertmanager/auth.yml \
  --cluster.listen-address=
