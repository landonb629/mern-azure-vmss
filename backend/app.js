const express = require('express')
const app = express()
const cors = require('cors')
const dbConnection = require('./db/db')
const authRoutes = require('./routes/auth')


app.use(cors());
app.use(express.json());

//routes
app.use('/api/v1/auth', authRoutes);

const start = async () => { 
    try { 
        await dbConnection();
        app.listen(3031, ()=> { 
            console.log("listening on port 3031")
        })
    } catch(error) { 
        console.log(error)
    }
}

start()