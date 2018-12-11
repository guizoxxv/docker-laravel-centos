FROM centos:7.5.1804

ENV APACHE_DOCUMENT_ROOT ${APACHE_DOCUMENT_ROOT:-/var/www/html/public}

RUN yum update -y

# Add PHP 7.2 repository
RUN yum install epel-release http://rpms.remirepo.net/enterprise/remi-release-7.rpm yum-utils -y && \
    yum-config-manager --enable remi-php72 && \
    yum update -y

RUN yum install vim wget curl unzip \ 
    httpd httpd-tools \
    php php-json php-gd php-mbstring php-pdo php-xml php-mysqlnd -y

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm -rf composer-setup.php

# Install Node.js
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash - && \
    yum install nodejs -y

# Copy custom apache configuration into container
COPY httpd.conf /etc/httpd/conf/httpd.conf

RUN yum clean all

EXPOSE 80

# Keep container active
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]