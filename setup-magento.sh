apt-get update -y

DEBIAN_FRONTEND=noninteractive apt install php php-fpm php-mysql php-bcmath php-xml php-zip php-curl php-mbstring php-gd php-tidy php-intl php-cli php-soap  libsodium-dev libsodium23 libssl-dev curl nginx -y

/etc/init.d/php8.1-fpm start
/etc/init.d/nginx start

curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/bin --filename=composer

sed -i 's/zlib.output_compression = .*/zlib.output_compression = On/g' /etc/php/8.1/fpm/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 25M/g' /etc/php/8.1/fpm/php.ini
sed -i 's/post_max_size = .*/post_max_size = 25M/g' /etc/php/8.1/fpm/php.ini
sed -i 's/memory_limit = .*/memory_limit = 256M/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = .*/max_execution_time = 180/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = .*/max_execution_time = 180/' /etc/php/8.1/cli/php.ini

cat <<EOL > /root/.config/composer/auth.json
{
    "http-basic": {
        "repo.magento.com": {
            "username": "c6f824f7d275f6b2036a05326304fd61",
            "password": "3ebfc61141fe9ecc7878b565d98e30b9"
        }
    }
}
EOL

cd /var/www/html
composer create-project --repository-url=https://repo.magento.com magento/project-community-edition=2.4.5 magento

cd magento
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R www-data:www-data .
chmod u+x bin/magento

#php bin/magento setup:install --base-url=http://172.27.59.199 --db-host=mysql --db-name=magentodb --db-user=magento --db-password=magento --admin-firstname=Admin --admin-lastname=Admin --admin-email=admin@domain.com --admin-user=admin --admin-password=admin@123 --language=en_US --currency=USD --timezone=UTC --backend-frontname=admin --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200

#php bin/magento indexer:reindex && php bin/magento se:up && php bin/magento se:s:d -f && php bin/magento c:f && php bin/magento module:disable Magento_TwoFactorAuth

