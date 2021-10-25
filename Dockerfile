FROM node:12-alpine AS base

WORKDIR /app
COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build && npm cache clean --force && rm -rf app/src

FROM node:12-alpine AS application

COPY --from=base /app/package*.json ./
RUN npm install --only=production
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
