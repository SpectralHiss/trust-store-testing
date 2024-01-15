FROM nginx:latest

COPY cert/ /etc/certs/my-secure-app/

COPY nginx.conf /etc/nginx/nginx.conf
