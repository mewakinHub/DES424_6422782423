FROM nginx
LABEL MAINTAINER "Teetawat Bussabarati"

# ARG MY_NAME=change_my_name
# ARG MY_ID=change_my_id

ENV MY_HOST localhost

COPY dotask.sh /dotask.sh
RUN chmod +x /dotask.sh

RUN apt-get update && apt-get install -y git sed
RUN mkdir /mycode && cd /mycode && git clone https://github.com/mewakinHub/DES424_6422782423.git
RUN cp -r /mycode/DES424_6422782423/src /usr/share/nginx/html/mygitweb

RUN echo "Running dotask.sh with CMD" && cat /dotask.sh
CMD ["sh", "/dotask.sh"]
