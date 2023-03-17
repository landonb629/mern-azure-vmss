import React from 'react';
import { useEffect, useState } from 'react';


const Home = () => { 
    const [token, setToken] = useState('')

    
    
    useEffect(()=> {
        const checkToken = () => { 
            const getToken = localStorage.getItem('token')
            setToken(getToken)
        }
       checkToken()       
    },[])

    return <h1>Welcome to your Home page! change made from CI/CD</h1>
}


export default Home;
