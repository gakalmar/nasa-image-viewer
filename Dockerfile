FROM node:14

WORKDIR /usr/src/nasa-potd

COPY . .

RUN cd app/backend && npm install

CMD [ "npm", "start"]

EXPOSE 3000