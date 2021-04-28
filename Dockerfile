# Stage 1
FROM node:10-alpine as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod

# Stage 2
FROM nginx:1.17.1-alpine
COPY --from=build-step /app/docs /usr/share/nginx/html
# Expose port 8080 instead of 80
RUN mkdir /etc/nginx/templates
RUN touch /etc/nginx/templates/default.conf.template
RUN echo "listen       ${NGINX_PORT};" >> /etc/nginx/templates/default.conf.template
