FROM node:22-alpine
LABEL "language"="nodejs"
LABEL "framework"="univer"

WORKDIR /src

RUN npm install -g pnpm@10.24.0

COPY . .

RUN pnpm install

RUN pnpm build

# Run build:demo with error output
RUN pnpm build:demo 2>&1 || true

# Debug: List all directories to find where dist was created
RUN echo "=== Searching for dist directories ===" && \
    find /src -type d -name "dist" -o -name "build" 2>/dev/null | head -20

# If /src/examples/dist doesn't exist, check alternatives
RUN if [ ! -d "/src/examples/dist" ]; then \
      echo "dist not found in /src/examples, checking alternatives..."; \
      ls -la /src/examples/ || echo "examples dir not found"; \
      ls -la /src/ | grep -E "dist|build" || echo "No dist/build in /src"; \
    fi

FROM zeabur/caddy-static

# Try to copy from the most likely location
COPY --from=0 /src/examples/dist /usr/share/caddy

EXPOSE 8080