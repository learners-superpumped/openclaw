FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY prisma ./prisma
COPY prisma.config.ts ./
RUN npx prisma generate
COPY tsconfig.json ./
COPY src ./src
RUN npx tsc
RUN cp src/legal/privacy.html src/legal/terms.html dist/legal/

FROM node:22-bookworm-slim
WORKDIR /app
COPY --from=build /app/package.json /app/package-lock.json* ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
COPY --from=build /app/src/generated ./dist/generated
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/prisma.config.ts ./
ENV NODE_ENV=production
USER node
EXPOSE 4000
CMD ["node", "dist/main.js"]
