FROM nginx:1.25-alpine

#Eliminar config default (opcional pero limpio)

RUN rm /etc/nginx/conf.d/default.conf

#Copiar HTML estático

COPY services/web/html /usr/share/nginx/html

#Puerto interno del contenedor

EXPOSE 80 

#Nginx ya trae el CMD correcto