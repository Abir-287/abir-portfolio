FROM node:18-alpine AS builder
WORKDIR /app

# Copier les fichiers de package d'abord
COPY package*.json ./
COPY next.config.mjs ./

# Installer TOUTES les dépendances (y compris devDependencies pour le build)
RUN npm ci

# Installer les dépendances manquantes spécifiques
RUN npm install --save-dev eslint
RUN npm install autoprefixer

# Copier le reste des fichiers
COPY . .

# Build de l'application
RUN npm run build

FROM node:18-alpine AS production
WORKDIR /app

# Installer seulement les dépendances de production
COPY package*.json ./
RUN npm ci --only=production

# Copier les fichiers construits
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/package.json ./

EXPOSE 3000
ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

CMD ["npm", "start"]