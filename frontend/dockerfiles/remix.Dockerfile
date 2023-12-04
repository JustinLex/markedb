# Node container for SSR using express and remix

# Set up development environment
# This container doubles as a hot-reloading frontend using vite
FROM docker.io/library/node:21.3.0-alpine AS development
ENV NODE_ENV=development
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY . /app
ENTRYPOINT npm start

# Build express SSR server modules
FROM development as builder
RUN npm run build-ssr

# Express SSR server runtime container
FROM docker.io/library/node:21.3.0-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY server.mjs /app
COPY --from=builder /app/build /app/build
ENTRYPOINT npm start
