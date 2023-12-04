# Nginx container for serving static assets and JS files
# Note that in local dev environments, requests for js files are handled by the frontend express server instead,
# and do not hit this nginx server. (This is for hot-reloading the JS files)

# Build CSR JS files
FROM docker.io/library/node:21.3.0-alpine AS builder
ENV NODE_ENV=development
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY . /app
RUN npm run build-csr

# Nginx server container
FROM docker.io/nginxinc/nginx-unprivileged:1.25.3-alpine-slim AS server
COPY --from=builder /app/public /var/www
COPY nginx.conf /etc/nginx/conf.d/
