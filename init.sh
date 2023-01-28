#!/bin/bash

# nginx sites available
directory=./docker/nginx/sites

# name of site
ext=".conf";
site_name="$1"
filename="$site_name$ext"
website="$site_name.test"
echo "$filename"


touch "$directory/$filename"

file_path="$directory/$filename"

# Confirm the file was created
if [ -f "$file_path" ]; then
  # create nginx site config
    echo "
server {

    listen 80;
    listen [::]:80;

    add_header X-Frame-Options \"SAMEORIGIN\";
    add_header X-Content-Type-Options \"nosniff\";
    charset utf-8;

    server_name $1.test;
    root /var/www/$2;
    index index.php index.html index.htm;

    location / {
         try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php$ {
        try_files \$uri /index.php =404;
        fastcgi_pass php8:9000;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        #fixes timeouts
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
    location = /robots.txt  {
        access_log off;
        log_not_found off;
    }


    error_log /var/log/nginx/laravel_error.log;
    access_log /var/log/nginx/laravel_access.log;
}
" > "$file_path"
chmod 775 "$file_path"
# put to hosts
os=$(uname -s)
# Check if the operating system is Ubuntu
if [ "$os" == "Linux" ] || [ "$os" == "ubuntu" ] || [ "$os" == "Darwin" ]; then
    # The path to the hosts file on Ubuntu
    hosts_file="/etc/hosts"
else
    # The path to the hosts file on Windows
    hosts_file="C:\Windows\System32\drivers\etc\hosts"
fi

echo "127.0.0.1 $website" | tee -a $hosts_file

docker-compose exec nginx nginx -s reload

else
    echo "check permission when create a file"
fi
