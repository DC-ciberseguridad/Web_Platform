FROM nginx:alpine

# Eliminar config default
RUN rm /etc/nginx/conf.d/default.conf

# Copiar nuestra config
COPY services/nginx/nginx.conf /etc/nginx/nginx.conf

# Puerto interno
EXPOSE 80

# Arranque
CMD ["nginx", "-g", "daemon off;"]