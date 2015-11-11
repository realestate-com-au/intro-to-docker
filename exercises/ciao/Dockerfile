FROM node:4.2

COPY package.json /app/

WORKDIR /app
RUN npm install

COPY index.js /app/

ENV PORT 5000
EXPOSE $PORT

CMD ["node", "/app/index.js"]
