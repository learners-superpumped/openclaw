FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY robots.txt /usr/share/nginx/html/robots.txt
COPY build/web /usr/share/nginx/html
EXPOSE 80
