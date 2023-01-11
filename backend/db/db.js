const mongoose = require('mongoose')

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://db:27017", { 
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: true
        })
    } catch(error) { 

    }
}

module.exports = dbConnection