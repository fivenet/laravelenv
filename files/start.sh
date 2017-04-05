#!/bin/bash

echo "user = $(stat -c '%u' /project/)" > /dev/shm/fpm-user.conf
echo "group = $(stat -c '%g' /project/)" >> /dev/shm/fpm-user.conf
echo "listen.mode = 0666" >> /dev/shm/fpm-user.conf

/usr/sbin/php-fpm7.1 -F
