#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to start..."
until mysqladmin ping -h mysql -u root -ppassword --silent; do
  sleep 1
done
echo "MySQL is ready!"

# Log in to MySQL
mysql -h mysql -u root -ppassword