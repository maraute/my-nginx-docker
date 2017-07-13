FROM ubuntu:latest
# 
#
#ENV http_proxy http://172.20.52.200:3128
#ENV https_proxy httpis://172.20.52.200:3128
#Define the ENV variable
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.0/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf
ENV fpm_www_conf /etc/php/7.0/fpm/pool.d/www.conf

RUN apt-get update

# Install nginx, php-fpm and supervisord from ubuntu repository
RUN apt-get install -y nginx php7.0-fpm supervisor && \
    rm -rf /var/lib/apt/lists/*

# Enable php-fpm on nginx virtualhost configuration
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
    echo "\ndaemon off;" >> ${nginx_conf}
RUN sed -i -e 's/;listen = \/run\/php\/php7.0-fpm.sock/listen = 127.0.0.1:9000/'  ${fpm_www_conf}

#Copy supervisor configuration
COPY supervisord.conf ${supervisor_conf}


RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

COPY index.html  /var/www/html
COPY vodafone.jpg  /var/www/html
COPY samsung.jpg  /var/www/html
COPY huawai.jpg  /var/www/html
COPY mar.php  /var/www/html

# Volume configuration
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Configure Services and Port
COPY start.sh /start.sh
CMD ["./start.sh"]

