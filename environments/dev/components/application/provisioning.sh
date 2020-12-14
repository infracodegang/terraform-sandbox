#!/bin/sh

# docker
sudo amazon-linux-extras install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo mkdir /opt/docker

# phpMyAdmin
sudo cat << 'EOF' > /opt/docker/docker-compose.yml
version: "3"

services:
  myadmin:
    image: phpmyadmin/phpmyadmin:${pma_version}
    ports:
      - "8081:80"
    networks:
      - frontend
      - backend
    environment:
#      PMA_HOSTS: <mysql_host1>[,<mysql_host2>]
      PHP_UPLOAD_MAX_FILESIZE: "512M"
      PMA_ABSOLUTE_URI: http://${admin_host}/pma/
    restart: always

volumes:
  db_data:

networks:
  frontend:
  backend:
EOF
sudo docker-compose -f /opt/docker/docker-compose.yml up -d

# mysql 5.7
sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community
sudo yum install -y mysql-community-client

# mysql 8.0
# yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
# yum-config-manager --enable mysql80-community
# yum-config-manager --disable mysql57-community
# yum install -y mysql-community-client

# redis
sudo amazon-linux-extras install -y epel
sudo yum install -y redis

# nginx
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cat << 'EOF' > /etc/nginx/nginx.conf
user  nginx nginx;
worker_processes  2;
worker_rlimit_nofile  65536;
pid  /var/run/nginx.pid;

events {
  worker_connections  2048;
}

http {
  real_ip_header    X-Forwarded-For;
  real_ip_recursive on;
  set_real_ip_from  ${vpc_cidr};

  log_format main '$remote_addr - $host $request_uri $remote_user [$time_iso8601] $scheme "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for" $request_time';

  access_log       /var/log/nginx/access.log  main;
  error_log        /var/log/nginx/error.log   warn;

  proxy_http_version 1.1;
  server_tokens    off;
  include          /etc/nginx/mime.types;
  default_type     application/octet-stream;
  charset          UTF-8;
  sendfile         on;
  tcp_nopush       on;
  gzip             on;
  gzip_vary        on;
  gzip_min_length  1k;
  gzip_types       text/plain text/css text/javascript
                   application/x-javascript application/javascript
                   application/json application/xml
                   image/png;

  server {
    access_log off;
    error_log off;
    log_not_found off;
    listen 80 default_server;
    root /var/www/html;
  }

  server {
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Signature $http_x_signature;
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;

    server_name  ${admin_host}
    client_max_body_size 512m;
    listen       80;
    error_page   403  /403.html;
    error_page   404  /404.html;
    error_page   500  /500.html;
    error_page   502  /502.html;
    error_page   503  /503.html;
    error_page   504  /504.html;

    location = /robots.txt  { log_not_found off; }
    location = /favicon.ico { access_log off; log_not_found off; }
    location ~* (403|404|500|502|503|504)\.html$ {
      root  /usr/share/nginx/html;
    }

    # for health check
    location / {
      add_header Content-Type text/plain;
      return 200 'OK';
    }

    # phpMyAdmin
    location /pma/ {
      if ($uri ~ \.(gif|jpg|png|ico|js|css)$) {
        access_log off;
      }
      access_log  /var/log/nginx/pma.access.log  main;
      error_log   /var/log/nginx/pma.error.log   warn;
      keepalive_timeout  0;
      rewrite /pma/(.*) /$1 break;
      proxy_pass  http://127.0.0.1:8081;
    }

    # admin site
    location /admin/ {
      access_log  /var/log/nginx/mgr.access.log  main;
      error_log   /var/log/nginx/mgr.error.log   warn;
      keepalive_timeout  0;
      rewrite /admin/(.*) /$1 break;
      proxy_pass  http://127.0.0.1:9100;
    }
  }
}
EOF
sudo systemctl reload nginx
