FROM nginx:alpine

# Copiar el HTML
COPY index.html /usr/share/nginx/html/index.html

# Crear configuración de Nginx que acepta puerto dinámico
RUN rm /etc/nginx/conf.d/default.conf

# Script de inicio personalizado
COPY <<EOF /start.sh
#!/bin/sh
PORT=\${PORT:-10000}
cat > /etc/nginx/conf.d/default.conf <<NGINX
server {
    listen \$PORT;
    server_name _;
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
NGINX
exec nginx -g 'daemon off;'
EOF

RUN chmod +x /start.sh

EXPOSE 10000

CMD ["/start.sh"]
