FROM ubuntu:16.04

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y php7.1-cli php7.1-fpm php7.1-opcache supervisor php-xdebug php-apcu 

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini
RUN echo "apc.enabled=1" >> /etc/php/7.1/fpm/php.ini
RUN echo "apc.enable_cli=1" >> /etc/php/7.1/cli/php.ini
RUN echo "realpath_cache_size=10M" >> /etc/php/7.1/cli/php.ini
RUN echo "realpath_cache_ttl=7200" >> /etc/php/7.1/cli/php.ini
RUN echo "realpath_cache_size=10M" >> /etc/php/7.1/fpm/php.ini
RUN echo "realpath_cache_ttl=7200" >> /etc/php/7.1/fpm/php.ini

RUN /usr/sbin/phpenmod opcache xdebug apcu

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini

RUN mkdir /log
RUN mkdir -p        /var/www
ADD build/default   /etc/nginx/sites-available/default
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN service php7.1-fpm start

EXPOSE 80
# End Nginx-PHP

RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

