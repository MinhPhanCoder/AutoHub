#!/bin/sh

# Wait for Nginx to start
sleep 5

# Check if we already have a certificate
if [ ! -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
    # Generate temporary self-signed certificate
    mkdir -p /etc/letsencrypt/live/${DOMAIN}
    openssl req -x509 -nodes -newkey rsa:4096 \
        -days 1 \
        -keyout /etc/letsencrypt/live/${DOMAIN}/privkey.pem \
        -out /etc/letsencrypt/live/${DOMAIN}/fullchain.pem \
        -subj "/CN=${DOMAIN}"
    cp /etc/letsencrypt/live/${DOMAIN}/fullchain.pem /etc/letsencrypt/live/${DOMAIN}/chain.pem

    # Get real certificate
    certbot certonly --webroot \
        --webroot-path=/var/www/certbot \
        --email "admin@${DOMAIN}" \
        --domains "${DOMAIN}" \
        --non-interactive \
        --agree-tos \
        --force-renewal

    # Reload Nginx to use new certificate
    nginx -s reload
fi

# Add cronjob for renewal
echo "0 */12 * * * certbot renew --quiet" | crontab -

# Keep container running
nginx -g "daemon off;"