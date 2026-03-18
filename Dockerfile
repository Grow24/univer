#
# Build Univer examples (static) and serve via Caddy.
#

FROM node:24 AS build

WORKDIR /app

# Enable pnpm via corepack (node images ship corepack)
RUN corepack enable && corepack prepare pnpm@10.24.0 --activate

COPY . .

# Install deps for the monorepo and build the demo output into /app/examples/local
RUN pnpm install --frozen-lockfile
RUN pnpm build:demo


FROM caddy:2-alpine AS runtime

WORKDIR /srv

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/examples/local /srv

EXPOSE 80

