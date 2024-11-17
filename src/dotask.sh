#!/bin/sh
echo "MY_HOST is set to: $MY_HOST"
ls /usr/share/nginx/html/mygitweb/check4.html  # Check if file exists
cat /usr/share/nginx/html/mygitweb/check4.html  # Display file contents before sed

# Modified sed command to handle variable replacement correctly
sed -i "s|<MY_HOST>|$MY_HOST|g" /usr/share/nginx/html/mygitweb/check4.html

cat /usr/share/nginx/html/mygitweb/check4.html  # Display file contents after sed
nginx -g 'daemon off;'
