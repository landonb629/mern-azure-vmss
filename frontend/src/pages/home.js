import React from 'react';
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';


const Home = () => { 
    const [token, setToken] = useState('')
    const navigate = useNavigate()

    const checkToken = () => { 
        const getToken = localStorage.getItem('token')
        setToken(getToken)

    }
    
    useEffect(()=> {
        checkToken()
        if (token !== '') { 
          console.log('found a token')
        } else {
            navigate('/')
        }
        
    },[navigate])
    return <h1>Welcome to your Home page!</h1>
}


export default Home;
