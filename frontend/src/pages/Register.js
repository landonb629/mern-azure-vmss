import { React } from 'react';
import { useState, useEffect } from 'react';
import axios from 'axios'
import FormRow from '../components/formRow'
import { useNavigate } from 'react-router-dom';

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
        try { 
            const response = await axios.post('http://20.85.226.218:3031/api/v1/auth/register', data)
            const returnData = await response;
            const {user_id, token } = returnData.data; // the data attribute is what holds the information sent back from the server 
            const payload = { 
                user_id: user_id,
                token: token
            }
            return payload;
        } catch (error) { 
            console.log(error)
        }
    }

    const loginUser = async(data) => { 
        try {
            const response = await axios.post('http://20.85.226.218:3031/api/v1/auth/login/', data)
            const returnData = await response;
            const {user_id, token } = returnData.data;
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
            const {user_id} = payload;
            setUser(user_id)
        } catch(error) { 
            console.log(error);
        }
        
    }
    // redirect is user is set
    useEffect(()=> { 

        if (user) { 
            navigate('/home')
        }
      },[user, navigate])

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