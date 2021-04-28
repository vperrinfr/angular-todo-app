# Stage 1
FROM node:10-alpine as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod

# Stage 2
FROM nginxinc/nginx-unprivileged
USER 101
CMD ["nginx-debug", "-g", "daemon off;"]
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build-step /app/docs /usr/share/nginx/html

