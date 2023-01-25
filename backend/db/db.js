const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://mern-app-demo.mongo.cosmos.azure.com:10255/users?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "mern-app-demo",
                password: "Lo4NsalsO2NgA5ywTn0sNl8CItM85qZbUK0IGcBudXW3xx5QFlujl4n7UwWWPueWz6hDbsSFrOOGACDbEgraSQ=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })

    } catch(error) { 

    }

}

module.exports = dbConnection