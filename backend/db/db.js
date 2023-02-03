const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://mern-app-demo.mongo.cosmos.azure.com:10255/users?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "mern-app-demo",
                password: "BtxVW4ch5JXlwUWOUYO1KGXplrG4lQYm86MqR3xL9RknIxtkZ1H2hWwIWooVAJlyxWkeDXyWxlaNACDbr0uweg=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })

    } catch(error) { 
        console.log(error)
    }
}

module.exports = dbConnection