

FROM node:22-alpine
LABEL "language"="nodejs"
LABEL "framework"="univer"

WORKDIR /src

RUN npm install -g pnpm@10.24.0

COPY . .

RUN pnpm install

RUN pnpm build

RUN pnpm build:demo

# Debug: Check what was actually created
RUN echo "=== Checking /src/examples ===" && \
    ls -la /src/examples/ && \
    echo "=== Checking for dist directories ===" && \
    find /src -type d -name "dist" 2>/dev/null || echo "No dist directories found"

FROM zeabur/caddy-static

# Copy the built demo files
COPY --from=0 /src/examples/dist /usr/share/caddy

EXPOSE 8080