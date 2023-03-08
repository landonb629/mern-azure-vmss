const express = require('express')
const app = express()
const cors = require('cors')
const path = require('path')
const {dbConnection, devConnection} = require('./db/db')
const authRoutes = require('./routes/auth')
const dotenv = require('dotenv')
dotenv.config();


app.use(cors());
app.use(express.json());


//routes
app.use('/api/v1/auth', authRoutes);

const start = async () => { 
    try {
        if (process.env.NODE_ENV === "development") { 
            await devConnection()
        } else {
            await dbConnection();
        }
        
        app.listen(3032, ()=> { 
            console.log(`listening on port 3032, with env: ${process.env.NODE_ENV} `)
        })
    } catch(error) { 
        console.log(error)
    }
}

start()