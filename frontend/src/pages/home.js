import React from 'react';
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';


const Home = () => { 
    const [token, setToken] = useState('')

    
    
    useEffect(()=> {
        const checkToken = () => { 
            const getToken = localStorage.getItem('token')
            setToken(getToken)
        }
       checkToken()
    },[])
    return <h1>Welcome to your Home page! rolling update complete</h1>
}


export default Home;
