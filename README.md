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

- Only Prometheus is password-protected (basic auth).
- **Alertmanager and Blackbox Exporter are NOT protected by default.**
- For production, you MUST:
  - Restrict access using firewall rules
  - Or set up a reverse proxy (e.g., Nginx) with authentication in front of these services

## Recommendations
- Never expose these ports directly to the internet without protection.
- Always use strong passwords and restrict access to trusted IPs.

## Services

- **Prometheus**
  - Accessible at: [http://[host]:9090](http://localhost:9090)
  - Protected by a simple password (set in `.env`) /login is : admin

- **Alertmanager**
  - Accessible at: [http://[host]:9093](http://localhost:9093)
  - **Warning:** No authentication by default. Freely accessible unless you add firewall or reverse proxy protection.

- **Blackbox Exporter**
  - Accessible at: [http://[host]:9115](http://localhost:9115)
  - **Warning:** No authentication by default. Freely accessible unless you add firewall or reverse proxy protection.

## Configuration
- Create a `docker/.env` file with the provided model,
  then set what you need.

### Example `.env` file
Copy and paste the following into `docker/.env` and edit values as needed:

```env
# Prometheus hashed password
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
