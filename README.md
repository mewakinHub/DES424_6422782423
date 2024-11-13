# testgit
This is a test program for DES424 (6422782423).
### Table of contents
* [Required Software](#required-software)
* [Installation](#installation)
* [Data preparation](#data-preparation)
* [Configuration](#configuration)
* [Run program](#run-program)
* [Output](#output)
## Required Software
* Item 1
* Item 2
* Item 3
## Run Program
* xx xxx


# docker HW check point 3
**use ARG as passing argument when building the image**
docker build --no-cache --build-arg MY_NAME=Teetawat --build-arg MY_ID=6422782423 -t mygitweb:1.1 .

docker run --name myweb_g -d -p 8080:80 mygitweb:1.1

# docker HW check point 4
**use ENV as passing evn value when running the container**

*Create a Shell Script for Environment Replacement (dotask.sh)*
```
#!/bin/sh
sed -i 's/<MY_HOST>/'"$MY_HOST"'/g' /usr/share/nginx/html/mygitweb/check4.html
nginx -g 'daemon off;'
```

docker build --no-cache -t mygitweb:1.4 .
docker run -d --name myweb_g -p 8080:80 mygitweb:1.4
docker run -d --name myweb_g -e MY_HOST=MyDockerOnVM -p 8080:80 mygitweb:1.4


