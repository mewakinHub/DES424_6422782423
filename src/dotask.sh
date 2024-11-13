#!/bin/sh
sed -i 's/<MY_HOST>/'"$MY_HOST"'/g' /usr/share/nginx/html/mygitweb/check4.html
nginx -g 'daemon off;'
