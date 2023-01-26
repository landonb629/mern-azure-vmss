const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://mern-app-demo.mongo.cosmos.azure.com:10255/users?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "mern-app-demo",
                password: "rGLxwttBiBTUvCosaMuKEz29c2hEi3ASwAdodVDBDmnX9jxJu3L1kHSFWPo6ysAWI0OBZ7aDNbFQACDbQhVtRQ=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })

    } catch(error) { 

    }
}

module.exports = dbConnection