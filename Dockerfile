FROM node:22 AS build

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json

RUN npm install

COPY . .

RUN npm run build


# Non-root nginx (uid 101, port 8080) so the pod can run under PSA restricted.
FROM nginxinc/nginx-unprivileged:alpine

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/build /usr/share/nginx/html
