const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://mern-app-demo.mongo.cosmos.azure.com:10255/users?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "mern-app-demo",
                password: "e7dQMM6iVBkHxahjHE9VakmXdjLKYLaxFAaINMMR6P903MzApBF567Ih9Gt06XEueS5UMwOCmAssACDbZyJrGQ=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })
        
    } catch(error) { 

    }

}

module.exports = dbConnection