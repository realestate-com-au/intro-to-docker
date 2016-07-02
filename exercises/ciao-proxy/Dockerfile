FROM nginx@sha256:0fe6413f3e30fcc5920bc8fa769280975b10b1c26721de956e1428b9e2f29d04

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy.conf.sh /nginx/proxy.conf.sh
COPY run /nginx/run

CMD ["/nginx/run"]

EXPOSE 80
