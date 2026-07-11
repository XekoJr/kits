FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html

# BACKEND_HOST/BACKEND_PORT are substituted into the nginx config at
# container start by nginx's built-in envsubst-on-templates support,
# so the reverse-proxy target is runtime-configurable without rebuilding.
ENV BACKEND_HOST=backend
ENV BACKEND_PORT=80

EXPOSE 80
