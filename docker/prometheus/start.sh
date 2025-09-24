#!/bin/sh
set -e

# Generate targets file from $TARGETS (comma or space separated)
_targets="${TARGETS:-}"
list=$(printf '%s' "$_targets" | sed 's/,/ /g' | xargs)
{
  echo "- labels:"
  echo "    group: prod"
  echo "  targets:"
  for t in $list; do
    [ -z "$t" ] && continue
    # Prepend https:// if not already present
    case "$t" in
      http*://*) echo "    - $t" ;;
      *) echo "    - https://$t" ;;
    esac
  done
} > /etc/prometheus/targets.yml

# Build alert rules from $SSL_DAYS (default 20)
: "${SSL_DAYS:=20}"
seconds=$(expr "$SSL_DAYS" \* 86400)
cat > /etc/prometheus/alert.rules.yml <<EOF
groups:
  - name: ssl-expiry
    rules:
      - alert: SSLCertificateExpiringSoon
        expr: (probe_ssl_earliest_cert_expiry - time()) < ${seconds}
        labels:
          severity: warning
        annotations:
          summary: 'SSL cert for {{ \$labels.instance }} expiring soon'
          description: 'Earliest cert expiry for {{ \$labels.instance }} is in < ${SSL_DAYS} days.'
EOF

# Generate bcrypt hash for PROM_PWD
if [ -z "$PROM_PWD_HASH" ]; then
  echo "PROM_PWD is not set!" >&2
  exit 1
fi


# Write auth.yml with the hash
cat <<EOF > /etc/prometheus/auth.yml
basic_auth_users:
  admin: "$PROM_PWD_HASH"
EOF

# Start Prometheus
exec /bin/prometheus --config.file=/etc/prometheus/prometheus.yml --web.config.file=/etc/prometheus/auth.yml --storage.tsdb.path=/prometheus --web.enable-lifecycle
