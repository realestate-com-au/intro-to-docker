FROM ubuntu:14.04

RUN apt-get update -qqy

RUN apt-get install -qqy software-properties-common
RUN apt-add-repository -y ppa:nginx/stable && apt-get update -qqy
RUN apt-get install -qqy nginx

COPY nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

COPY proxy.conf /container/proxy.conf

COPY run /container/run
CMD ["/container/run"]

EXPOSE 80
