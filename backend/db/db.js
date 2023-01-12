const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://loginapp.mongo.cosmos.azure.com:10255/test?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "loginapp",
                password: "3T9sJTcnNEF3Vf3VIppSfSMIhaBnWkGfSufAqoD12d8Qb6HUd70RGwiLxz2IfI8xWxVxEuwZ0KsYACDbVFV50w=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })
    } catch(error) { 

    }
}

module.exports = dbConnection