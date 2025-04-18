#!/bin/bash

# Exit on error
set -e

# Get domain from environment variable with default
DOMAIN=${DOMAIN:-localhost}

# Function to wait for Nginx to start
wait_for_nginx() {
    echo "Waiting for Nginx to start..."
    while ! nc -z localhost 80; do
        sleep 1
    done
    echo "Nginx is up!"
}

# Create directory structure for SSL certificates
mkdir -p /etc/letsencrypt/live/${DOMAIN}
mkdir -p /var/lib/letsencrypt

# Generate self-signed certificate first for Nginx to start
if [ ! -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
    openssl req -x509 -nodes -newkey rsa:4096 \
        -days 1 \
        -keyout /etc/letsencrypt/live/${DOMAIN}/privkey.pem \
        -out /etc/letsencrypt/live/${DOMAIN}/fullchain.pem \
        -subj "/CN=${DOMAIN}"
    cp /etc/letsencrypt/live/${DOMAIN}/fullchain.pem /etc/letsencrypt/live/${DOMAIN}/chain.pem
fi

# Start Nginx in background
nginx &

# Wait for Nginx to start
wait_for_nginx

# Request the Let's Encrypt certificate
certbot --nginx \
    --non-interactive \
    --agree-tos \
    --email "admin@${DOMAIN}" \
    --domains "${DOMAIN}" \
    --keep-until-expiring \
    --redirect \
    --must-staple

# Add cronjob for auto-renewal
echo "0 */12 * * * certbot renew --quiet" | crontab -

# Stop background Nginx
nginx -s stop

# Start Nginx in foreground
echo "Starting Nginx in foreground..."
nginx -g 'daemon off;'