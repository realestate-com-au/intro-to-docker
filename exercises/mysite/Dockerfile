FROM ubuntu:latest

RUN apt-get update && apt-get install -y -q apache2

RUN mkdir -p /var/lock/apache2 /var/log/apache2

env APACHE_RUN_USER    www-data
env APACHE_RUN_GROUP   www-data
env APACHE_PID_FILE    /var/run/apache2.pid
env APACHE_RUN_DIR     /var/run/apache2
env APACHE_LOCK_DIR    /var/lock/apache2
env APACHE_LOG_DIR     /var/log/apache2
env LANG               C

CMD ["apache2", "-D", "FOREGROUND"]

COPY docs/* /var/www/html/
