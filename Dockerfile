FROM node:20

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg imagemagick webp git python3 make g++ procps && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

# Step 1: Install all deps WITHOUT scripts (prevents libsignal native build failure)
RUN npm install --legacy-peer-deps --ignore-scripts

# Step 2: Download prebuilt better-sqlite3 binary (no source compilation)
RUN npm_config_build_from_source=false npm install better-sqlite3@11.10.0 --legacy-peer-deps

# Step 3: Remove sharp installed without binary and reinstall it fresh with postinstall
RUN rm -rf node_modules/sharp && \
    npm install --platform=linux --arch=x64 sharp@0.32.6 --legacy-peer-deps

COPY . .

EXPOSE 3000 5000

ENV NODE_ENV=production

CMD ["node", "index.js"]
