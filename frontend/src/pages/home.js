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
       console.log('running the token check')
       checkToken()
       if (token !== '') { 
        console.log('we should log the user in')
       }
       
    },[])
    return <h1>Welcome to your Home page! rolling update complete</h1>
}


export default Home;
