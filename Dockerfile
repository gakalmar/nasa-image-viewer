FROM node:14

WORKDIR /usr/src/nasa-potd

COPY . .

RUN ./app/backend/npm i

CMD [ "npm", "start"]

EXPOSE 3000