#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1
systemctl enable nginx.service
systemctl start nginx.service
#journalctl -u nginx.service

mkdir /data/nginx/cache -p

cat << 'EOF' > /etc/nginx/nginx.conf;
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
  worker_connections 1024;
}

http {
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

  access_log  /var/log/nginx/access.log  main;


  sendfile            on;
  tcp_nopush          on;
  tcp_nodelay         on;
  keepalive_timeout   65;
  types_hash_max_size 4096;

  include             /etc/nginx/mime.types;
  default_type        application/octet-stream;
  include /etc/nginx/conf.d/*.conf;

  proxy_cache_path /data/nginx/cache keys_zone=cache:15m max_size=1g; # CACHING CONFIGURATION
  proxy_cache_methods GET;

  server {
    listen       80;
    listen       [::]:80;
    server_name  _;

    location / {
      proxy_cache cache;
      expires 5m;

      proxy_pass https://${bucket_domain_name}/index.html; # ACCESS S3 ASSETS
    }
  }
}
EOF

systemctl restart nginx.service
curl localhost:80