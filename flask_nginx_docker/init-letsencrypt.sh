#!/bin/bash

# Get the domain from environment variable
DOMAIN=${DOMAIN:-localhost}

# Wait for Nginx to start
sleep 5

# Request the certificate
certbot --nginx \
  --non-interactive \
  --agree-tos \
  --email admin@${DOMAIN} \
  --domains ${DOMAIN} \
  --redirect \
  --keep-until-expiring

# Add cronjob for auto-renewal
echo "0 */12 * * * certbot renew --quiet" | crontab -

# Start Nginx in the foreground
nginx -g 'daemon off;'