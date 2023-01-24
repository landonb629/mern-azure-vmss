const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://10.10.2.4:10255/test?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "",
                password: ""
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })
    } catch(error) { 

    }

}

module.exports = dbConnection