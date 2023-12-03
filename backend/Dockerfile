# Cachable docker build tutorial: https://www.lpalmieri.com/posts/fast-rust-docker-builds/
# We use alpine builders since it lets us statically link musl C in order to use scratch for runtime

FROM docker.io/library/rust:1.74.0-alpine AS chef
RUN apk add musl-dev
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release --bin backend

FROM scratch AS runtime
WORKDIR /app
COPY --from=builder /app/target/release/backend /app/backend
ENTRYPOINT ["/app/backend"]
