FROM node:24-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm prune --production

FROM gcr.io/distroless/nodejs24-debian13
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["dist/main.js"]