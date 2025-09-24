#!/bin/sh
set -e

# Generate auth.yml for basic authentication
if [ -z "$PROM_PWD_HASH" ]; then
  echo "PROM_PWD_HASH is not set!" >&2
  exit 1
fi

cat <<EOF > /etc/blackbox/auth.yml
basic_auth_users:
  admin: "$PROM_PWD_HASH"
EOF

exec /bin/blackbox_exporter \
  --config.file=/etc/blackbox/blackbox.yml \
  --web.config.file=/etc/blackbox/auth.yml
