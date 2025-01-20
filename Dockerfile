# Use the official Bun image
# See all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1 as base

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install dependencies into a temporary directory to speed up future builds
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json /temp/dev/
COPY bun.lockb /temp/dev/  # Include bun.lockb if it exists to ensure consistent installs
RUN cd /temp/dev && bun install

# Install production dependencies (excluding devDependencies)
FROM base AS prodinstall
RUN mkdir -p /temp/prod
COPY package.json /temp/prod/
COPY bun.lockb /temp/prod/  # Include bun.lockb here as well
RUN cd /temp/prod && bun install --production

# Copy node_modules from the install step
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules /usr/src/app/node_modules
COPY . .

# Set the environment to production
ENV NODE_ENV=production

# Optionally, you can add build or test steps if necessary
# RUN bun test
# RUN bun run build

# Final image: Copy production dependencies and source code into the final image
FROM base AS final
WORKDIR /usr/src/app
COPY --from=prodinstall /temp/prod/node_modules /usr/src/app/node_modules
COPY --from=prerelease /usr/src/app .

# Set the user to bun (important for Bun container)
USER bun

# Expose the port that your app is listening to
EXPOSE 3000/tcp

# Start the application with Bun (this assumes that your app is located in ./src/index.ts)
ENTRYPOINT [ "bun", "run", "./src/index.ts" ]
