FROM node

WORKDIR /usr/src/app 

COPY package.json . 

COPY package-lock.json .

RUN npm install 

EXPOSE 6060

ENTRYPOINT ["npm", "start"]
