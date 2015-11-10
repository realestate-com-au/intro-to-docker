FROM node:4.2

COPY index.js /app/
COPY package.json /app/

WORKDIR /app
RUN npm install

EXPOSE 8080

CMD ["node", "/app/index.js"]
