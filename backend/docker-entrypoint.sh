#!/bin/sh
set -e

cd /var/www/html

if [ ! -f .env ]; then
    cp .env.example .env
fi

# Generate an APP_KEY if none is set (env var takes precedence over .env,
# so an empty APP_KEY passed through by docker-compose still needs handling)
if [ -z "$APP_KEY" ] && ! grep -q '^APP_KEY=base64' .env; then
    php artisan key:generate --force
fi

# Re-export APP_KEY from .env so the value actually used by artisan above
# (whether pre-existing or freshly generated) also reaches the Apache/PHP
# process below -- otherwise an empty APP_KEY inherited from the container
# environment would keep shadowing the one written to .env.
GENERATED_KEY=$(grep '^APP_KEY=' .env | cut -d '=' -f2-)
if [ -n "$GENERATED_KEY" ]; then
    export APP_KEY="$GENERATED_KEY"
fi

# Wait for the database to accept connections before migrating
if [ -n "$DB_HOST" ]; then
    echo "Waiting for database at ${DB_HOST}:${DB_PORT:-5432}..."
    for i in $(seq 1 30); do
        if php -r "exit(@fsockopen('${DB_HOST}', ${DB_PORT:-5432}) ? 0 : 1);"; then
            break
        fi
        sleep 1
    done
fi

php artisan migrate --force

php artisan config:cache
php artisan route:cache

exec "$@"
