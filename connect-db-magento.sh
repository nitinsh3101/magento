#!/bin/bash

php bin/magento setup:install --base-url=http://dockeroncloud.com --db-host=mysql --db-name=magentodb --db-user=magento --db-password=magento --admin-firstname=Admin --admin-lastname=Admin --admin-email=admin@domain.com --admin-user=admin --admin-password=admin@123 --language=en_US --currency=USD --timezone=UTC --backend-frontname=admin --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200

php bin/magento indexer:reindex && php bin/magento se:up && php bin/magento se:s:d -f && php bin/magento c:f && php bin/magento module:disable Magento_TwoFactorAuth

/etc/init.d/php8.1-fpm start

/etc/init.d/nginx start

/etc/init.d/nginx reload

sleep infinity

