FROM node:14

WORKDIR /usr/src/nasa-potd

COPY . .

WORKDIR /usr/src/nasa-potd/app/backend

RUN npm install

CMD [ "npm", "start"]

EXPOSE 3000