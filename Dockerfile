FROM ubuntu:22.04
COPY setup-magento.sh .
RUN sh setup-magento.sh
COPY default /etc/nginx/sites-available/default
WORKDIR /var/www/html/magento
COPY connect-db-magento.sh .
