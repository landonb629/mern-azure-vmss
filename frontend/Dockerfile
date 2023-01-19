FROM node:17-alpine as Builder

WORKDIR /usr/src/frontend 

COPY package.json . 

COPY package-lock.json . 

RUN npm install 

EXPOSE 3000

ENTRYPOINT ["npm", "start"]


