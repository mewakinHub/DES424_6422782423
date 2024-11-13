FROM nginx
LABEL MAINTAINER "Teetawat Bussabarati"

ARG MY_NAME=change_my_name
ARG MY_ID=change_my_id

RUN apt-get update && apt-get install -y git sed
RUN mkdir /mycode && cd /mycode && git clone https://github.com/mewakinHub/DES424_6422782423.git
RUN cp -r /mycode/testgit/src /usr/share/nginx/html/mygitweb

RUN export MY_NAME=$MY_NAME && sed -i 's/<MY_NAME>/'"${MY_NAME}"'/gi' /usr/share/nginx/html/mygitweb/index.html
RUN export MY_ID=$MY_ID && sed -i 's/<MY_ID>/'"${MY_ID}"'/gi' /usr/share/nginx/html/mygitweb/index.html