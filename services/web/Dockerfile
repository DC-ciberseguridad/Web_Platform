FROM nginx:1.25-alpine

# Copiar nuestra config
COPY services/web/nginx.conf /etc/nginx/nginx.conf

# Copiar HTML y CSS
COPY services/web/html /usr/share/nginx/html
COPY services/web/css /usr/share/nginx/html/css

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]