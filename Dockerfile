FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

RUN microdnf --nodocs -y install httpd php \
  && microdnf clean all \
  && rpm -e $(rpm -qa *rpm*) $(rpm -qa *dnf*) $(rpm -qa *libsolv*) $(rpm -qa *hawkey*) $(rpm -qa yum*)

ADD index.php /var/www/html

RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf \
  && mkdir /run/php-fpm \
  && chgrp -R 0 /var/log/httpd /var/run/httpd /run/php-fpm \
  && chmod -R g=u /var/log/httpd /var/run/httpd /run/php-fpm
  
EXPOSE 8080

USER 1001

CMD php-fpm & httpd -D FOREGROUND
