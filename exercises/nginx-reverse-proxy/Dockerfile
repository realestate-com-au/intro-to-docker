FROM ubuntu:14.04

RUN apt-get update -qqy

RUN apt-get install -qqy software-properties-common
RUN apt-add-repository -y ppa:nginx/stable && apt-get update -qqy
RUN apt-get install -qqy nginx

RUN rm /etc/nginx/sites-enabled/default

COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy.conf.sh /nginx/proxy.conf.sh
COPY run /nginx/run

CMD ["/nginx/run"]

EXPOSE 80
