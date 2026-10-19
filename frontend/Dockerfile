FROM node:22-alpine AS dependencies
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM dependencies AS build
COPY app ./app
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build && rm -rf .next/cache

FROM node:22-alpine AS production-dependencies
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1
COPY --from=production-dependencies --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/.next ./.next
COPY --from=build --chown=node:node /app/package.json ./package.json
USER node
EXPOSE 3000
CMD ["npm", "start"]
