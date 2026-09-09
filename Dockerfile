# Example: Node.js application
# Replace with your own Dockerfile for other languages
# See docs/DOCKERFILE_EXAMPLES.md for Python, Go, and more
#
# Pinned to a digest for reproducibility. Dependabot's docker ecosystem
# refreshes this on a schedule. Node 20 reached EOL on 2026-04-30, so
# this targets Node 22 (active LTS through 2027-04).

FROM node:22-alpine@sha256:c610fcdfb1d5b4740dd70c284ed3cb16bb857e0f7166196e36a5501df7a3aa32

# The base image bundles vulnerable node-tar; retain npm with a patched toolchain.
RUN npm install --global npm@11.19.1 --ignore-scripts && npm cache clean --force

WORKDIR /app
COPY --chown=node:node app/ .

# Run as the non-root `node` user that ships with the official image.
USER node

EXPOSE 3000
HEALTHCHECK --interval=10s --timeout=5s --retries=3 --start-period=10s \
  CMD wget -qO /dev/null http://localhost:${PORT:-3000}/health || exit 1
CMD ["node", "server.js"]
