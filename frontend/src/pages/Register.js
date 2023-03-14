import { React } from 'react';
import { useState, useEffect } from 'react';
import axios from 'axios'
import FormRow from '../components/formRow'
import { useNavigate } from 'react-router-dom';
import config from '../config/config.json'


const initialState = {
    name: '',
    email: '',
    password: '',
    isMember: false
}

const Register = () => { 
    const navigate = useNavigate();
    const [request, setRequest] = useState(initialState);
    const [user, setUser] = useState('')

    // register a user and update the state value for user, to allow for redirect
    const onSubmit = async (e) => { 
        e.preventDefault()
        try { 
            if (!request.isMember) {
                const registerStatus = await registerUser(request);
                await checkUser(registerStatus);
            } else { 
                const loginStatus = await loginUser(request);
                await checkUser(loginStatus)
            }
        } catch(error) { 
            console.log(error)
        }
    }

    //request function 
    const registerUser = async(data) => { 
        const reqConfig = {
            method: 'POST',
            headers: { 
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        }
            const response = await fetch(`/api/v1/auth/register`, reqConfig)
            const returnData = await response.json();
            const {user_id, token } = returnData; // the data attribute is what holds the information sent back from the server 
            const payload = { 
                user_id: user_id,
                token: token
            }
            return payload;
    }

    const loginUser = async(data) => { 
        try {
            const reqConfig = {
                method: 'POST',
                headers: { 
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }
            const response = await fetch(`/api/v1/auth/login`, reqConfig)
            const returnData = await response.json();
            const {user_id, token } = returnData;
            const payload = { 
                user_id: user_id,
                token: token
            }
            return payload;
        } catch(error) { 
            console.log(error)
        }
    }
    
    // check user function 
    const checkUser = async (payload) => { 
        try { 
            const {user_id, token} = payload;
            localStorage.setItem('token', token)
            setUser(user_id)
        } catch(error) { 
            console.log(error);
        }
    }
    const checkToken = async () => { 
        try { 
            const getToken = localStorage.getItem('token')
            if (!getToken) { 
                console.log('no token was found')
            } else { 
                navigate('/home')
            }
        } catch(error) { 
            console.log('error')
        }
    }
    

    // redirect is user is set
    useEffect(()=> { 
        checkToken()
        if (user) { 
            navigate('/home')
        } 
      },[user])

    const changeHandler = (e) => { 
        setRequest({...request, [e.target.name]: e.target.value})
    }
    const toggleMember = () => { 
        setRequest({...request, isMember: !request.isMember})
    }
       

     return(
        <div>
            <h3>{request.isMember ? 'login' : 'register'}</h3>
            <form onSubmit={onSubmit}>
                <FormRow 
                    type="text"
                    name="name"
                    value={request.name}
                    clickHandler={changeHandler}
                    disabled={request.isMember ? true : false}
                />
                <FormRow 
                    type="text"
                    name="email"
                    value={request.email}
                    clickHandler={changeHandler}
                />
                <FormRow 
                    type="text"
                    name="password"
                    value={request.password}
                    clickHandler={changeHandler}
                />
                <button>{request.isMember ? "Login" : "Register"}</button>
            </form>
            <div>
                <button onClick={toggleMember}>{request.isMember ? "Register" : "Login"}</button>
            </div>
        </div>
    )
}

export default Register