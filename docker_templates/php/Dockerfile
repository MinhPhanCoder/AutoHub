FROM php:8.2-fpm

# Create non-root user
RUN addgroup --system appgroup && adduser --system --group appgroup

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code
COPY ./app .

# Install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --optimize-autoloader

# Set permissions
RUN chown -R appgroup:appgroup /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Switch to non-root user
USER appgroup

EXPOSE 8080

# Run PHP-FPM
CMD ["php-fpm"]