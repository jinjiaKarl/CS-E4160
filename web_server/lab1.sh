#!/usr/bin/env bash

sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx

sed  -i 's!^server {! \
upstream apache { \
   server lab2:80; \
} \
upstream node { \
  server lab3:8080; \
} \
server { \
    location /apache { \
        #rewrite /apache(/|$)(.*) /$2 break; \
        proxy_pass http://apache/; \
        #proxy_pass http://apache; \
    } \
    location /node { \
      proxy_pass http://node/; \
    } \
!g' /etc/nginx/sites-available/default

