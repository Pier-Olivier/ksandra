# kSandra Monitoring Stack

## Description
Let's Encrypt does not alert anymore when there is
an SSL renewal issue. If you do not monitor your
certificate renewal process, you may have a surprise.

kSandra requests your URLs every 24h
and sends you an email alert if its SSL certificate
has less than 20 days of validity.

## Information
This is an open project, so do not hesitate to
make it your own, twist it, chew it, and propose
improvements.

## Security Notes

- All services (Prometheus, Alertmanager, and Blackbox Exporter) are password-protected with basic authentication.
- All services use the same credentials configured via `PROM_PWD_HASH` in the `.env` file.
- Login username is: **admin**
- Password is the one you used to generate the bcrypt hash.

## Recommendations
- Never expose these ports directly to the internet without additional protection.
- Always use strong passwords and consider restricting access to trusted IPs.
- Change the default username if needed by modifying the respective `start.sh` files.

## Services

- **Prometheus**
  - Accessible at: [http://[host]:9090](http://localhost:9090)
  - Protected with basic auth (username: admin)

- **Alertmanager**
  - Accessible at: [http://[host]:9093](http://localhost:9093)
  - Protected with basic auth (username: admin)

- **Blackbox Exporter**
  - Accessible at: [http://[host]:9115](http://localhost:9115)
  - Protected with basic auth (username: admin)

## Configuration
- Create a `docker/.env` file with the provided model,
  then set what you need.

### Example `.env` file
Copy and paste the following into `docker/.env` and edit values as needed:

```env
# Password hash for all services (Prometheus, Alertmanager, Blackbox)
# Username is 'admin' for all services
# To generate a hash use: https://bcrypt-generator.com/
PROM_PWD_HASH=''

# IMPORTANT: mail system is using STARTTLS
# Prefer port 587 in SMTP_SMARTHOST
SMTP_SMARTHOST=smtp.my-domain.com:587
SMTP_FROM=contact@my-domain.com
SMTP_USERNAME=contact@my-domain.com
SMTP_PASSWORD=xxx
# Email to alert when a certificate is expiring
ALERT_TO=contact@my-domain.com

# List of domains to be checked
# Separated by space or comma
TARGETS=my-domain.com www.my-domain.com www.my-other-domain.com

# Certificate must be valid for at least 20 days
SSL_DAYS=20

# In production: "always"
# For testing: "no"
RESTARTING=no

# To fixe Docker Network IP. If useless delete it
# And delet docker/docker-compose.yml lines 8 to 12
SUBNET_IP=172.176.0
```

```bash
docker compose up -d
```

Then you can sleep peacefully.
