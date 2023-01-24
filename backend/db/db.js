const mongoose = require('mongoose')
const dotenv = require('dotenv')
dotenv.config();

const dbConnection = () => { 
    try {  
        return mongoose.connect("mongodb://10.10.2.4:10255/test?ssl=true&replicaSet=globaldb",{
            auth: { 
                username: "mern-app-demo",
                password: "M5ePiImFAvz71D4pbx7uQ7ug1V6pA8OauyY3umuP4d8JIPwCxc2AQAsGhr9w89tmuii8MuhSMDsQACDblLD2Mg=="
            },
            useNewUrlParser: true,
            useUnifiedTopology: true,
            retryWrites: false
        })
    } catch(error) { 

        
    }

}

module.exports = dbConnection