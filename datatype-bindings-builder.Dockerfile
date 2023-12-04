# Docker container for building the backend datatype bindings locally

FROM docker.io/library/rust:1.74.0-alpine AS chef
RUN apk add musl-dev
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
COPY backend /app
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS codegen
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY backend /app
RUN cargo test
