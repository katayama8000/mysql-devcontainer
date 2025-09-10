#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to start..."
until mysqladmin ping -h mysql -u root -ppassword --silent; do
  sleep 1
done
echo "MySQL is ready!"

# Connect to MySQL
./connect_to_mysql.sh