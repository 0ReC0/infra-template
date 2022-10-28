FROM node:16.16.0-alpine as build

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm cache clean --force
COPY . ./
RUN npm ci && npm run build

# Stage - Production
FROM nginx:1.17-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]