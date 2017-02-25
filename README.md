# PHP-7.1 Local Development Docker Container: Ubuntu, Nginx and PHP Stack

Based on: https://github.com/fideloper/docker-nginx-php

PHP files are stored in www/

Nginx files are stored in log/

Access via: http://localhost:8000/

# Usage

```bash
# Build the container.
docker build -t local-dev .

# Run it.
docker-compose up
```