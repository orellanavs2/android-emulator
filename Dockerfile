FROM nginx:alpine

# Copiar archivos HTML
COPY index.html /usr/share/nginx/html/index.html

# Exponer puerto 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
